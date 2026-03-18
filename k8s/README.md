# Mini-PaaS v2 (Kubernetes)

This directory contains the Kubernetes manifests for the Kubernetes-based version of the Mini-PaaS project.

## Structure

- `base/`
  - shared Kubernetes resources
  - currently contains the shared Ingress definition

- `apps/app1/`
  - Deployment
  - Service
  - HPA

- `apps/app2/`
  - Deployment
  - Service
  - HPA

- `apps/app3/`
  - Deployment
  - Service
  - HPA

- `apps/app4/`
  - Deployment
  - Service
  - HPA

## Architecture mapping from v1 to v2

- Docker run logic -> Deployment
- Manual port exposure -> Service
- NGINX host routing -> Ingress
- Manual scaling idea -> Horizontal Pod Autoscaler
- Basic health handling -> readiness and liveness probes

## Current scope

This project runs locally on Minikube inside WSL and demonstrates:
- multi-application deployment
- internal service exposure
- host-based ingress routing
- health checks
- resource requests and limits
- horizontal pod autoscaling
- basic metrics visibility

## Notes

The current Prometheus + Grafana + cAdvisor monitoring setup is a transitional host/container monitoring stack and is not yet a fully Kubernetes-native observability stack.
