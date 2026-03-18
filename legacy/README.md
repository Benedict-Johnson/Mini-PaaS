# Legacy Mini-PaaS (Docker + NGINX + Bash)

This folder documents the original version of the project before Kubernetes migration.

## Original deployment model

- Build an app image from an app folder
- Find an available host port
- Stop and replace old container
- Run container manually with Docker
- Generate or update NGINX site config
- Reload NGINX
- Expose app using host-based routing such as `app1.local`

## Why this still exists

This is kept intentionally because the Kubernetes version is an evolution of the original manual orchestration approach.

## What Kubernetes will replace later

- Manual container lifecycle management
- Manual service exposure
- Manual reverse proxy config generation
- Manual scaling logic

## What Kubernetes will NOT replace by itself

- CI/CD pipelines
- Git-based automation
- End-to-end production platform concerns
