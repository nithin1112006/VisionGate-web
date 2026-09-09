# VisionGate Web - Render Deployment Guide

This guide explains how to host the **VisionGate Web Portal** on [Render](https://render.com).

The repository includes pre-compiled production web assets (`web_build/`), an automated build script (`render-build.sh`), a Render Blueprint configuration (`render.yaml`), and a `Dockerfile`.

---

## Method 1: Render Static Site (Recommended — 100% Free & Fast)

Render Static Sites are free, fast, globally distributed on CDN, and come with free SSL.

1. Go to your **[Render Dashboard](https://dashboard.render.com/)**.
2. Click **New +** → **Static Site**.
3. Connect your repository: `https://github.com/nithin1112006/VisionGate-web`.
4. Configure the deployment settings:
   - **Name**: `visiongate-web` (or your preferred name)
   - **Branch**: `master`
   - **Build Command**: `./render-build.sh` (or leave empty)
   - **Publish Directory**: `web_build`
5. Under **Advanced** → **Redirects / Rewrites**:
   - **Type**: `Rewrite`
   - **Source**: `/*`
   - **Destination**: `/index.html`
   *(This ensures client-side Flutter routing works when refreshing any page)*
6. Click **Create Static Site**.
   - Your site will deploy in seconds and receive an automatic URL like `https://visiongate-web.onrender.com`.

---

## Method 2: Render Blueprint (1-Click Setup)

Render automatically detects `render.yaml` in this repository:

1. In Render Dashboard, click **New +** → **Blueprint**.
2. Select `VisionGate-web` repository.
3. Render will read `render.yaml` and configure the static site, build script, rewrite rules, and headers automatically.
4. Click **Apply**.

---

## Method 3: Render Web Service (Docker Container)

If you prefer running as an active Web Service with Nginx:

1. Click **New +** → **Web Service**.
2. Select `VisionGate-web` repository.
3. Select **Environment**: `Docker`.
4. Render will automatically build the `Dockerfile` and serve the web app over Nginx on port 80.
5. Click **Deploy Web Service**.

---

## Backend Connectivity Note

The Flutter Web application connects directly to the live backend API at:
`https://app.srishakthicgpa.in` (configured in `siet_sync/lib/config/college_ip_config.dart`).
Ensure CORS headers on your backend allow requests from your Render domain (or wildcard `*`), which is already supported by FastAPI's CORS middleware.
