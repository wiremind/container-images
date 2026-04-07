# AGENTS.md

This file provides guidance to [agents](https://agents.md/) when working with code in this repository.

## Repository Purpose

Custom container images built by Wiremind, published to GitHub Container Registry (ghcr.io/wiremind/).

## Architecture

Images are in `images/<name>/` with:

- `docker-bake.hcl` - Bake configuration with versions matrix and tags
- `Containerfile*` - One or more Containerfiles (e.g., `Containerfile.debian13`, `Containerfile.debian13-hardened`)

## Adding a New Image

1. Create `images/my-image/docker-bake.hcl`:

   ```hcl
   variable "REGISTRY" {
     default = "ghcr.io/wiremind"
   }

   variable "VERSIONS" {
     default = ["1.0.0", "1.1.0"]
   }

   group "default" {
     targets = ["my-image"]
   }

   target "my-image" {
     name       = "my-image-${replace(v, ".", "-")}"
     matrix     = { v = VERSIONS }
     context    = "."
     dockerfile = "Containerfile"
     tags       = ["${REGISTRY}/my-image:${v}"]
     args       = { UPSTREAM_TAG = v }
     platforms  = ["linux/amd64"]
   }
   ```

2. Create `images/my-image/Containerfile`:

   ```dockerfile
   # syntax=docker.io/docker/dockerfile-upstream:1.20.0
   ARG UPSTREAM_TAG=1.0.0
   FROM docker.io/library/base:${UPSTREAM_TAG}
   # customizations
   ```

## Environment Variables

Shared variables are centralized in `.envrc` (root):
- `DEBIAN_SNAPSHOT_VERSION` - Debian snapshot for reproducible builds

Usage:
- **Local**: `direnv allow` or `source .envrc`
- **CI**: Sourced by `.github/workflows/bake.yml` before builds
- **Bake**: Variables read via HCL `variable` with empty default (env override)
- **Containerfile**: Received via `args` in bake target, declared as `ARG` (no default)

## Local Development

```bash
# Load environment
direnv allow  # or: source .envrc

# Build locally
docker buildx bake -f images/haproxy/docker-bake.hcl --print  # dry-run
docker buildx bake -f images/haproxy/docker-bake.hcl          # build

# Lint
hadolint images/my-image/Containerfile
```

## CI/CD Workflows

- **bake.yml** (main): Detects changed images, builds with bake, pushes, signs with Cosign
- **test.yml** (PR): Hadolint on changed Containerfiles
- **security.yml** (post-build + weekly): Trivy and Kubescape scans

## Key Files

- `.envrc` - Centralized environment variables (DEBIAN_SNAPSHOT_VERSION, etc.)
- `.github/workflows/bake.yml` - Main build workflow
- `images/*/docker-bake.hcl` - Bake configs
- `renovate.json` - Automated updates
