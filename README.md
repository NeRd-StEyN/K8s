# 🚀 Kubernetes Demo App

A simple Node.js application containerized with Docker and orchestrated using Kubernetes (Minikube). This project demonstrates the full workflow from local code to a public internet link.

---

## 📂 Project Structure

- `app.js`: Simple Node.js web server.
- `Dockerfile`: Instructions to build the Docker image.
- `deployment.yaml`: Manages the application pods and replicas.
- `service.yaml`: Provides a stable networking entry point to the app.

---

## 🛠️ Prerequisites

Before running this project, ensure you have the following installed:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## 🚀 Local Setup & Deployment

Follow these steps in order to run the app on your local machine:

### 1. Start the Environment
```powershell
minikube start
```

### 2. Connect Terminal to Minikube
This allows Docker to build images directly into Minikube's internal registry.
```powershell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

### 3. Build & Apply
```powershell
# Build the container image
docker build -t nerdsteyn/kube-demo-app .

# Apply Kubernetes configurations
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 4. Open the App
```powershell
minikube service demo-service
```

---

## 🌐 Sharing with the World (Public Tunnel)

If you want to share a live link to your local app with anyone, use **Cloudflare Tunnel**:

1. **Terminal 1:** Create local port-forwarding
   ```powershell
   kubectl port-forward service/demo-service 8080:80
   ```

2. **Terminal 2:** Start the Cloudflare Tunnel
   ```powershell
   cloudflared tunnel --url http://localhost:8080
   ```
   *Note: Use the random link generated in the terminal output (e.g., `https://random-name.trycloudflare.com`).*

---

## 🔄 Updating Your Code
If you make changes to `app.js`, simply rebuild the image and restart the pods:
```powershell
docker build -t nerdsteyn/kube-demo-app .
kubectl rollout restart deployment demo-deployment
```
