
## Building and Pushing the PIA Docker Images  

> **TL;DR** – Build the image natively for each platform, push to Docker Hub, then create a multi‑architecture manifest.

---

### 1️. Build (and push) the *ARM 64* image

```bash
docker build -t ethanscully/pia:3.6.2-arm64 --push .
```
---

### 2. Build (and push) the *AMD 64* image

```bash
docker build -t ethanscully/pia:3.6.2-amd64 --push .
```
---

### 3. Combine the platform images into a single manifest

Once both images are on Docker Hub, create a multi‑arch manifest so that `docker pull` will automatically fetch the correct one.

```bash
docker buildx imagetools create \
  --tag ethanscully/pia:3.6.2 \
  ethanscully/pia:3.6.2-arm64 \
  ethanscully/pia:3.6.2-amd64

# Create the explicit latest tag
docker buildx imagetools create \
  --tag ethanscully/pia:latest \
  ethanscully/pia:3.6.2-arm64 \
  ethanscully/pia:3.6.2-amd64

```
---

#### Prerequisites

- Docker 20.10+ with **BuildKit** and **Buildx** enabled.  
- Logged in to Docker Hub (`docker login`).  
- The Dockerfile is configured to build the same image on both architectures.

---