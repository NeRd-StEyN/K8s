# 🔄 Development Workflow: Making Changes Visible

This guide explains how to update your app's code or its infrastructure and see the results live.

---

## 🚀 The GitOps Way (Modern & Automatic)

GitOps works differently depending on whether you are changing the **Code** (app.js) or the **Infrastructure** (YAML).

### Case A: Changing Infrastructure (YAML Files)
*Example: Changing replicas from 2 to 5.*
1.  **Edit the YAML**: Open `deployment.yaml` and change the value.
2.  **Push to Git**: 
    ```powershell
    git add .
    git commit -m "scale to 5 replicas"
    git push origin main
    ```
3.  **Result**: ArgoCD sees the YAML change and updates the cluster **immediately**.

### Case B: Changing Application Code (.js, .css, .html)
*Example: Changing "rom 🚀" to "Hello 🚀".*
1.  **Edit the Code**: Change your `app.js`.
2.  **Build & Push Image**: Since Kubernetes runs images, you must create a new one:
    ```powershell
    docker build -t your-username/kube-app:v2 .
    docker push your-username/kube-app:v2
    ```
3.  **Update the Manifest**: Open `deployment.yaml` and change the `image` to `your-username/kube-app:v2`.
4.  **Push to Git**:
    ```powershell
    git add .
    git commit -m "update code to v2"
    git push origin main
    ```
5.  **Result**: ArgoCD sees the **Image Tag changed in the YAML** and pulls the new code!

---

## 🚜 The Manual Way (Traditional & Fast Local)
*Use this for fast testing without touching GitHub or Docker Hub.*

### Case A: Changing Application Code (.js, .css, React)
1.  **Edit Your Code**: Modify your local files (e.g., `app.js`).
2.  **Rebuild Locally**:
    ```powershell
    docker build -t kube-app:local .
    ```
3.  **Inject into Minikube**:
    ```powershell
    minikube image load kube-app:local
    ```
4.  **Restart the Pods**: 
    Since the image name (`kube-app:local`) is the same, you must tell Kubernetes to pull the new version of that image:
    ```powershell
    kubectl rollout restart deployment demo-deployment -n prod-namespace
    ```

### Case B: Changing Infrastructure (YAML Files)
1.  **Edit the YAML**: Modify your local `deployment.yaml` or `service.yaml`.
2.  **Apply Directly**:
    ```powershell
    kubectl apply -f deployment-gitops/manifests/deployment.yaml
    kubectl apply -f deployment-gitops/manifests/service.yaml
    ```

---

## 🛰️ Summary of "The Trigger"

| Type of Change | What triggers the update? |
| :--- | :--- |
| **Infrastructure (YAML)** | Pushing the YAML file to GitHub. |
| **App Code (.js)** | Pushing a **YAML change** that points to a **New Image Tag**. |

---

### 💡 Pro Tip: Why didn't my `.js` push update the site?
If you push `app.js` but **don't** update the `image:` tag in your `deployment.yaml`, ArgoCD thinks nothing has changed! You must always update the image version in your YAML to "trigger" the update.
