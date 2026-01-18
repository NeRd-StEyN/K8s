# 🔄 Update Guide: How to Apply Changes

This guide explains how to update your app's code (JS/HTML) or infrastructure (YAML) using both the **Automated (GitOps)** and **Manual** methods.

---

## 🚀 1. The GitOps Way (Modern & Automated)
*Since you have GitHub Actions and ArgoCD set up, this is the easiest way.*

### Case A: Changing Application Code (.js, .html, .css)
1.  **Edit your code**: Change something in `app.js`.
2.  **Push to Git**:
    ```powershell
    git add .
    git commit -m "Update homepage message"
    git push origin main
    ```
3.  **The Result**: **GitHub Actions** will automatically build the image, push it to Docker Hub, and update your `deployment.yaml`. **ArgoCD** will then see the change and update your site.

### Case B: Changing Infrastructure (YAML Files)
*Example: Changing replicas from 2 to 5 in `deployment.yaml`.*
1.  **Edit the YAML**: Modify the file locally.
2.  **Push to Git**:
    ```powershell
    git add .
    git commit -m "Scale to 5 replicas"
    git push origin main
    ```
3.  **The Result**: **ArgoCD** detects the YAML change on GitHub and updates your local cluster immediately.

---

## 🚜 2. The Manual Way (Traditional & Local)
*Use this for fast local testing without pushing to GitHub.*

### Case A: Changing Application Code (.js, .html, .css)
1.  **Edit your code**: Change your local files.
2.  **Build image**:
    ```powershell
    docker build -t kube-app:local .
    ```
3.  **Inject into Minikube**:
    ```powershell
    minikube image load kube-app:local
    ```
4.  **Restart Pods**:
    ```powershell
    kubectl rollout restart deployment demo-deployment -n prod-namespace
    ```

### Case B: Changing Infrastructure (YAML Files)
1.  **Edit the YAML**: Modify your local `deployment.yaml` or `service.yaml`.
2.  **Apply Directly**:
    ```powershell
    kubectl apply -f deployment-gitops/manifests/deployment.yaml
    ```

---

## 🛰️ Which one to use?

| Scenario | Best Method | Why? |
| :--- | :--- | :--- |
| **Real Update** | **GitOps** | Everything is automated and tracked in Git history. |
| **Quick Local Test** | **Manual** | Faster feedback loop; no need to push to GitHub. |
| **Scaling Up** | **GitOps** | Safe and documented in your version control. |

---

### 💡 Pro Tip
If you push code and nothing happens, check the **Actions** tab on your GitHub repository to see if the build failed due to a typo or permission issue!
