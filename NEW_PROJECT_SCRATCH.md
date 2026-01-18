# 🆕 Creating a New Project From Scratch

This guide explains how to build a simple "Hello World" Kubernetes project from zero.

---

## 🏗️ Step 1: Create the App
1.  **Create a folder**: `mkdir my-new-app && cd my-new-app`
2.  **Initialize Node.js**: `npm init -y`
3.  **Install Express**: `npm install express`
4.  **Create `app.js`**:
    ```javascript
    const express = require('express');
    const app = express();
    app.get('/', (req, res) => res.send('New Project Live! 🌟'));
    app.listen(3000, () => console.log('Server running on 3000'));
    ```

---

## 🐳 Step 2: Containerize (The Dockerfile)
Create a file named `Dockerfile`:
```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "app.js"]
```

---

## ☸️ Step 3: Kubernetes Manifests
Create a folder `k8s/` and add two files:

**`k8s/deployment.yaml`**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-username/my-app:v1 # Change this!
        ports:
        - containerPort: 3000
```

**`k8s/service.yaml`**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 3000
  type: NodePort
```

---

## 🚀 Step 4: Choose Your Path

### Path A: The GitOps Way (Recommended)
1.  **Create a Repository** on GitHub.
2.  **Push your code**:
    ```powershell
    git init
    git add .
    git commit -m "initial commit"
    git remote add origin YOUR_URL
    git push -u origin main
    ```
3.  **Define the ArgoCD Application**:
    Instead of clicking buttons in the ArgoCD UI, you can write a file called `argo-app.yaml` inside your project:

    **`argo-app.yaml`**:
    ```yaml
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: my-new-app
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: 'https://github.com/YOUR_USERNAME/YOUR_REPO.git'
        targetRevision: HEAD
        path: k8s  # The folder where your deployment.yaml is
      destination:
        server: 'https://kubernetes.default.svc'
        namespace: my-app-namespace
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
          - CreateNamespace=true
    ```

4.  **Connect to ArgoCD**:
    Run this one command on your laptop to tell ArgoCD about your project:
    ```powershell
    kubectl apply -f argo-app.yaml
    ```
    *From now on, ArgoCD will manage everything automatically!*

### Path B: The Manual Way (Fast Testing)
1.  **Build**: `docker build -t my-app:v1 .`
2.  **Load**: `minikube image load my-app:v1`
3.  **Deploy**: 
    ```powershell
    kubectl apply -f k8s/deployment.yaml
    kubectl apply -f k8s/service.yaml
    ```
4.  **Open**: `minikube service my-app-service`

---

## 📝 Key Differences to Remember

| Step | GitOps Setup | Manual Setup |
| :--- | :--- | :--- |
| **Hosting** | Requires a GitHub Repo | Entirely on your Laptop |
| **Logic** | GitHub ➡️ ArgoCD ➡️ Cluster | Laptop ➡️ Docker ➡️ Cluster |
| **Updates** | Automatic on `git push` | Manual `kubectl apply` |
| **Complexity** | Higher setup, lower maintenance | Lower setup, higher maintenance |
