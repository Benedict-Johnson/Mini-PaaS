# Mini-PaaS Architecture Notes

## Project evolution story

This project started as a manual local platform for deploying multiple containerized applications using:

- Docker
- Bash automation
- NGINX reverse proxy
- Prometheus / Grafana / cAdvisor

The next version migrates the platform toward Kubernetes-based orchestration while staying local-first using Minikube.

## Honest scope

This is not a cloud platform.
This is not real multi-tenancy.
This is not a production-grade PaaS.

It is a local orchestration project that demonstrates the evolution from:
- manual deployment automation
to
- Kubernetes-backed application orchestration

## Architecture mapping

### Old model
- `./deploy.sh app3`
- Docker build
- Docker run
- host port allocation
- NGINX config generation
- NGINX reload

### New model
- `kubectl apply -f ...`
- Deployment manages Pods
- Service provides stable networking
- Ingress handles HTTP routing
- HPA scales replicas based on metrics

## Why this is interview-defensible

Because it shows:
- understanding of containerization first
- reverse proxy routing knowledge
- operational scripting
- migration toward declarative orchestration
- realistic local platform engineering progression
