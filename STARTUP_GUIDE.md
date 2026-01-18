# 🚀 Startup Guide: From Restart to Live Site

This guide explains how to get your server running after you have restarted your laptop.

---

## 🛠️ Phase 0: The Foundation (Required for Both Ways)

Before you do anything, you must start the container engine:
1.  **Open Docker Desktop**: Wait for the whale icon to turn solid green.
2.  **Start Minikube**: Open your terminal and run:
    ```powershell
    minikube start
    ```

---

## 🏗️ Option A: The GitOps Way (Modern & Automated)
*Use this for your actual production workflow.*

### 1. Push Your Changes
You don't build images manually. Just push your code to GitHub:
```powershell
git add .
git commit -m "update my awesome app"
git push origin main
```

### 2. Verify in ArgoCD
ArgoCD will detect the push and update the cluster for you.
*   **Open Dashboard**: `minikube service argocd-server -n argocd`
*   **Check Status**: Ensure the app says `Synced` and `Healthy`.

### 3. Visit the Live Site
```powershell
minikube service demo-service -n prod-namespace
```

---

## 🚜 Option B: The Manual Way (Traditional & No GitOps)
*Use this if you want to test locally without pushing to GitHub.*

### 1. Build the Package
Turn your code into a Docker image manually:
```powershell
docker build -t kube-app:manual .
```

### 2. Inject into Cluster
Since Minikube is a separate environment, you must manually load the image:
```powershell
minikube image load kube-app:manual
```

### 3. Deploy Manually
Apply your instructions directly to Kubernetes:
```powershell
kubectl apply -f deployment-gitops/manifests/deployment.yaml
kubectl apply -f deployment-gitops/manifests/service.yaml
```

### 4. Visit the Live Site
```powershell
minikube service demo-service
```

---

## 📊 Summary Table

| Step | GitOps (ArgoCD) | Manual (Traditional) |
| :--- | :--- | :--- |
| **Command** | `git push` | `kubectl apply` |
| **Image** | Automated | `docker build` |
| **Effort** | Low (One Command) | High (Multiple Commands) |
| **Best For** | Real Work / Production | Fast Local Experimenting |
