# 🚀 Kubernetes GitOps with ArgoCD

This project demonstrates a production-grade **GitOps** workflow using **ArgoCD** and **Kubernetes**. Instead of manually managing the cluster with `kubectl`, we use Git as the "Single Source of Truth."

## 🏗️ Project Structure

```text
.
├── deployment-gitops/
│   ├── argo-config/
│   │   └── application.yaml      # ArgoCD Control Center (Management Code)
│   └── manifests/
│       └── deployment.yaml       # Kubernetes Application Manifests (Desired State)
└── Dockerfile                    # App Containerization
```

## 🛠️ How it was Implemented

### 1. Separation of Concerns
We divided the configuration into two parts:
- **Manifests**: The standard Kubernetes files (`deployment.yaml`, `service.yaml`, etc.) that describe how the app should run.
- **Argo Config**: The instructions for ArgoCD itself, telling it which GitHub repo to watch and where to deploy the manifests.

### 2. Defining the "Application" Resource
We created an ArgoCD `Application` object. This is the bridge between Git and Kubernetes. Key configurations include:
- **Repo URL**: `https://github.com/NeRd-StEyN/K8s.git`
- **Path**: `deployment-gitops/manifests`
- **Destination**: `prod-namespace`

### 3. Enabling Automation
We enabled **Automated Sync Policy** with the following features:
- **Self-Healing**: Automatically reverts manual changes made via terminal.
- **Pruning**: Deletes resources from the cluster if they are removed from Git.
- **Auto-Namespace**: Creates the target namespace if it doesn't exist.

---

## 🌟 GitOps Benefits Demonstrated

### 🔄 1. Self-Healing (Anti-Drift)
- **Action**: Manually scaled replicas to 8 via terminal.
- **Result**: ArgoCD detected the drift from Git (which said 2 replicas) and automatically scaled it back down.
- **Benefit**: Ensures the cluster stays exactly as defined in the code.

### ⏪ 2. Instant Rollback
- **Action**: Pushed a broken image to Git, then ran `git revert`.
- **Result**: The cluster restored the working version in seconds.
- **Benefit**: Standardizes recovery; if you can use Git, you can fix production.

### 🛡️ 3. Disaster Recovery
- **Action**: Deleted the entire `prod-namespace`.
- **Result**: ArgoCD recreated the namespace and all pods almost instantly.
- **Benefit**: Infrastructure is now "disposable" and easily recreatable from scratch.

### 📋 4. Full Audit Trail
- **Action**: Checked `git log`.
- **Result**: Every change to the infrastructure is documented with an author, date, and reason.
- **Benefit**: Compliance, security, and easy debugging.

---

## 🚀 How to Deploy Changes
1. Modify files in `deployment-gitops/manifests/`.
2. `git add .`
3. `git commit -m "your change description"`
4. `git push origin main`
5. **ArgoCD** will detect the change and update the cluster automatically.
