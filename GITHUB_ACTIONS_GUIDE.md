# 🤖 GitHub Actions: The Automation Engine

This guide explains how your GitHub Actions workflow works and how to set it up.

---

## 🛠️ What is GitHub Actions?
It is a **CI (Continuous Integration)** tool. Every time you push code to GitHub, it wakes up a virtual computer (the "Runner") to build your app and prepare it for deployment.

### What our script `.github/workflows/deploy.yml` does:
1.  **Checkout**: Downloads your code into the runner.
2.  **Login**: Authenticates with your Docker Hub account.
3.  **Build**: Runs `docker build` using a unique ID (the Git Commit Hash).
4.  **Push**: Sends your new image to Docker Hub.
5.  **Update YAML**: Automatically edits your `deployment.yaml` to use the new image version and pushes that change back to your repo.

---

## 🔑 Required Setup (Do this ONCE)
For security, you must never put your passwords in the code. Instead, we use **GitHub Secrets**.

### 1. Generate a Docker Token
*   Go to [hub.docker.com](https://hub.docker.com/) ➡️ Account Settings ➡️ Security.
*   Create a **New Access Token** and copy it.

### 2. Add Secrets to GitHub
*   Go to your Repository ➡️ **Settings** ➡️ **Secrets and variables** ➡️ **Actions**.
*   Add these two:
    *   `DOCKER_USERNAME`: Your username (e.g., `nerdsteyn`).
    *   `DOCKER_PASSWORD`: The Token you just copied.

---

## 🏃 Every Time You Develop
With this setup, you no longer need to build Docker images on your laptop.

### Your New Workflow:
```powershell
# 1. Write Code
# 2. Push to GitHub
git add .
git commit -m "added a new button"
git push origin main
```

### How to Monitor the Robot:
1.  Go to the **"Actions"** tab on GitHub.
2.  Click on your latest commit.
3.  You can watch the logs in real-time as it builds and pushes your image.

---

## ✅ Benefits of this Setup
*   **Consistency**: The image is built in a clean environment every time.
*   **Speed**: You can keep coding while GitHub handles the heavy building.
*   **Version History**: Every single deployment is linked to a specific Git commit, making rollbacks easy.
*   **Hands-Free**: ArgoCD sees the YAML update from GitHub and finishes the job. **Total human touch = 1 push.**

---

### 💡 Troubleshooting
*   **Red Cross ❌**: If the action fails, click on it to see the logs. It's usually a wrong Docker password or a typo in the YAML.
*   **Infinite Loop**: We added `paths-ignore` to ensure that when the robot updates the YAML, it doesn't trigger *another* build.
