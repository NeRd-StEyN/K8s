# 🔄 Development Workflow: Making Changes Visible

This guide explains how to update your app's code or configuration and see the results live.

---

## 🚀 The GitOps Way (Modern & Automatic)
*This is the workflow your project is designed for.*

### 1. Edit Your Code
Modify `app.js` or any file in your project.
*   *Example:* Change `res.send("rom 🚀")` to `res.send("Update Successful! ✅")`.

### 2. Push to GitHub
Open your terminal and run:
```powershell
git add .
git commit -m "update homepage text"
git push origin main
```

### 3. The "Wait or Force" Phase
*   **Wait**: ArgoCD checks GitHub every 3 minutes.
*   **Force (Instant)**: Open ArgoCD (`minikube service argocd-server -n argocd`) and click **Refresh** then **Sync**.

### 4. Verify
Refresh your browser tab where the app is running.
*   *If the tab is closed, run:* `minikube service demo-service -n prod-namespace`

---

## 🚜 The Manual Way (Traditional & Fast Local)
*Use this if you don't want to commit every small design tweak.*

### 1. Edit Your Code
Modify your local files.

### 2. Rebuild the Image
You must create a new package for your changes:
```powershell
docker build -t kube-app:v2 .
```

### 3. Load Into Minikube
```powershell
minikube image load kube-app:v2
```

### 4. Update the Deployment
Open `deployment-gitops/manifests/deployment.yaml` and update the `image` field to `kube-app:v2`. Then run:
```powershell
kubectl apply -f deployment-gitops/manifests/deployment.yaml
```

### 5. Verify
Kubernetes will kill the old pods and start new ones with your updated code.

---

## ⚖️ Which one should I use?

| Scenario | Recommended Way | Why? |
| :--- | :--- | :--- |
| **Fixing a Bug** | **GitOps** | Keeps a history of the fix in Git. |
| **New Feature** | **GitOps** | Ensures your whole team (and production) gets the update. |
| **Fast CSS Tweaks** | **Manual** | Faster feedback loop without filling Git with "small fix" commits. |
| **Scaling (Replicas)** | **GitOps** | Just change the number in YAML and push; it's safest. |

---

### 💡 Pro Tip: Using Skaffold
If you want the **best of both worlds** (instant updates AND Kubernetes), run:
```powershell
skaffold dev
```
*Skaffold will watch your files and run the "Manual" steps for you automatically every time you press **Save**.*
