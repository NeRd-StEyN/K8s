# 📊 Monitoring & Logging Guide

This guide explains how to track the health of your application (Monitoring) and read its diary (Logging) using the professional **Prometheus, Grafana, and Loki** stack.

---

## 🌡️ Part 1: Monitoring (Prometheus & Grafana)
Monitoring tells you "Is the system healthy?" (CPU, RAM, Uptime).

### 1. Installation (via Helm)
If not already installed, run:
```powershell
# Add the store
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install the "Monitoring Station"
helm install my-stack prometheus-community/kube-prometheus-stack
```

### 2. Access the Dashboard
Since you are on Windows/Minikube, you must create a tunnel:
```powershell
minikube service my-stack-grafana
```
*Note: Keep this terminal open while you use the website!*

### 3. Log In Credentials
- **Username:** `admin`
- **Password:** Run this to reveal it:
  ```powershell
  $encoded = kubectl get secret my-stack-grafana -o jsonpath="{.data.admin-password}"
  [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encoded))
  ```

### 4. What to look at?
Search for these pre-built dashboards in Grafana:
- **Kubernetes / Compute Resources / Pod**: Select your `demo-app` to see live CPU/RAM graphs.

---

## 📋 Part 2: Logging (Loki)
Logging tells you "What exactly happened?" (Error messages, app events).

### 1. Installation (via Helm)
```powershell
# Add the store
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Loki (Stores the logs)
helm install loki grafana/loki-stack
```

### 2. How to read Logs in Grafana
1. Open your Grafana website.
2. Click the **"Explore"** (compass) icon on the left.
3. Change the data source to **"Loki"**.
4. Type this in the query box: `{app="demo-app"}`.
5. Watch your app logs scroll by in real-time!

---

## 🛠️ Useful Quick Commands

| Goal | Command |
| :--- | :--- |
| **Check Health** | `kubectl get pods` |
| **Instant Logs** | `kubectl logs -f <pod-name>` |
| **Resource Usage**| `kubectl top pods` |
| **Troubleshoot** | `kubectl describe pod <pod-name>` |

---

## 🆘 Troubleshooting "Stuck" Pods
If you see `ImagePullBackOff` or `ErrImagePull`:
1. **Restart Connection:** `minikube stop` then `minikube start`.
2. **Force Retry:** `kubectl delete pod <pod-name>` (Kubernetes will try to download it again immediately).
