# 🚀 Mini-PaaS

> A local Platform-as-a-Service that evolved from Docker-based manual deployments into a Kubernetes-native orchestration system running on Minikube — with a full CI/CD pipeline and monitoring stack.

[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Minikube](https://img.shields.io/badge/Runtime-Minikube-F5A623?logo=kubernetes&logoColor=white)](https://minikube.sigs.k8s.io/)
[![Prometheus](https://img.shields.io/badge/Monitoring-Prometheus-E6522C?logo=prometheus&logoColor=white)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Dashboards-Grafana-F46800?logo=grafana&logoColor=white)](https://grafana.com/)
[![Status](https://img.shields.io/badge/Environment-Local%20Only-yellow)]()

---

## 📌 What Is This?

Mini-PaaS is a **learning-driven infrastructure project** that simulates a Platform-as-a-Service environment on a local machine. It started as a Bash + Docker + NGINX setup and was systematically rebuilt into a Kubernetes-based system with automated deployments, health checks, autoscaling, and monitoring.

This project is scoped to **local development** using Minikube — it is not a cloud-deployed system.

---

## 🔄 Evolution: Legacy → Improved

| Aspect | 🗂 Legacy System | ⚡ Improved System |
|---|---|---|
| **Runtime** | Docker (manual `docker run`) | Kubernetes via Minikube |
| **Routing** | NGINX reverse proxy | Kubernetes Ingress |
| **Scaling** | Manual container restarts | Horizontal Pod Autoscaler (HPA) |
| **Automation** | Bash scripts | GitHub Actions CI/CD pipeline |
| **Health Checks** | None | Liveness & Readiness Probes |
| **Resource Control** | None | CPU/Memory requests & limits |
| **Monitoring** | None | Prometheus + Grafana + cAdvisor |
| **Deployment Model** | Imperative | Declarative (YAML manifests) |

---

## 🗂 Legacy System Snapshot

The original system used:

- Bash script (`deploy.sh`) to build and run containers
- Manual port assignment per application
- NGINX reverse proxy for routing between services
- No health checks, autoscaling, or resource management

This system is preserved in the repository to highlight the architectural transition to Kubernetes.

---

## 🏗 Architecture

<div align="center">
<img width="642" height="511" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/18313bc5-02ac-4bce-a793-1460ece201cb" />
</div>

---

## ⚙️ CI/CD Pipeline

The pipeline is triggered on every `push` to the repository.

> ⚠️ Since the Kubernetes cluster runs locally on Minikube, a **self-hosted runner** is required to bridge GitHub Actions (cloud) with the local environment.
> This allows CI/CD pipelines to execute `kubectl` and Docker commands directly against the local cluster.

**Flow:**
1. **Trigger** — Push to `main` kicks off the workflow
2. **Matrix Build** — Multiple apps are built in parallel using a job matrix
3. **Self-Hosted Runner** — A runner in WSL executes the deployment script locally
4. **Deploy Script** — `deploy-k8s.sh` builds Docker images directly inside Minikube's Docker environment (`eval $(minikube docker-env)`) and applies `kubectl` manifests
5. **Rollout** — Kubernetes performs a rolling update automatically

<div align="center">
<img width="537" height="432" alt="CI/CD Pipeline" src="https://github.com/user-attachments/assets/47c5b673-fcdb-4b9a-bd07-0e6d31a610fb" />
</div>

---

## ✨ Features

- 🗂 **Multi-application deployment** — Multiple independent apps managed from a single repo
- 🤖 **Automated CI/CD** — Push-to-deploy via GitHub Actions with a self-hosted WSL runner
- 🌐 **Ingress-based routing** — Custom domain routing (e.g., `app1.local`, `app2.local`)
- 📈 **Horizontal Pod Autoscaling** — HPA scales pods based on CPU utilization
- 🩺 **Health checks** — Liveness and readiness probes for every deployment
- 🔒 **Resource management** — CPU/memory requests and limits per container
- 📊 **Local monitoring stack** — Prometheus, Grafana, cAdvisor, and metrics-server

---

## 📁 Project Structure
```
mini-paas/
│
├── app1/
│   ├── Dockerfile
│   └── index.html
│
├── app2/
├── app3/
├── app4/
│
├── k8s/
│   ├── base/
│   │   └── ingress.yaml
│   │
│   ├── apps/
│   │   ├── app1/
│   │   │   ├── deployment.yaml
│   │   │   ├── service.yaml
│   │   │   └── hpa.yaml
│   │   ├── app2/
│   │   ├── app3/
│   │   └── app4/
│   │
│   └── README.md
│
├── monitoring/
│   ├── docker-compose.yml
│   └── prometheus.yml
│
├── scripts/
│   └── deploy-k8s.sh
│
├── legacy/
│   └── README.md
│
├── docs/
│   └── architecture-notes.md
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── deploy.sh                  # legacy deploy script
├── .gitignore
└── README.md
```

---

## 🚢 Deployment Flow
```
1. Developer pushes code to GitHub
         │
         ▼
2. GitHub Actions detects push → triggers workflow
         │
         ▼
3. Self-hosted runner (WSL) picks up the job
         │
         ▼
4. deploy-k8s.sh builds Docker image using Minikube's Docker daemon
   → eval $(minikube docker-env)
   → docker build + kubectl apply -f k8s/apps/<app>/
         │
         ▼
5. Kubernetes performs rolling update
   → Old pods terminate gracefully
   → New pods pass readiness probes before serving traffic
```

---

## 📊 Monitoring

The monitoring stack runs via Docker Compose alongside the Kubernetes cluster.

| Component | Role | URL |
|---|---|---|
| **Prometheus** | Scrapes metrics from cAdvisor and app endpoints | http://localhost:9090 |
| **cAdvisor** | Exposes per-container CPU, memory, and network metrics | http://localhost:8082 |
| **metrics-server** | Provides resource metrics consumed by HPA | — |
| **Grafana** | Visualizes metrics via pre-configured dashboards | http://localhost:3000 |

<div align="center">
<img width="1917" height="855" alt="Grafana Dashboard" src="https://github.com/user-attachments/assets/4ff27a23-aefc-42a9-a68c-f8ba88f98d95" />
</div>

---

## 🖼 Screenshots

**Kubernetes Cluster Output**

<div align="center">
<img width="1190" height="486" alt="kubectl output" src="https://github.com/user-attachments/assets/461f2670-a6fd-48ec-9182-ddd85a2a467f" />
</div>

**App Routing via Ingress**

<div align="center">
<img width="760" height="258" alt="curl routing" src="https://github.com/user-attachments/assets/57b44779-b993-4cd9-b636-690c6530eeb8" />
</div>

**GitHub Actions — Successful Run**

<div align="center">
<img width="1451" height="675" alt="GitHub Actions" src="https://github.com/user-attachments/assets/b8698706-5529-40e7-afcb-ebdbf8dba83c" />
</div>

---

## 🧠 Key Learnings

- **Container → Orchestration mindset shift** — Moving from imperative `docker run` commands to declarative Kubernetes manifests changes how you reason about infrastructure
- **Kubernetes primitives in practice** — Hands-on experience with Deployments, Services, Ingress, ConfigMaps, HPA, and probes
- **CI/CD with self-hosted runners** — Designing a pipeline that bridges cloud-hosted GitHub Actions with a local Minikube environment via WSL
- **Resource management** — Understanding the impact of CPU/memory requests and limits on scheduling and autoscaling decisions

---

## ⚠️ Limitations

- **Local-only** — Runs entirely on Minikube; not deployed to any cloud provider
- **Not production-grade** — No multi-tenancy, no RBAC, no network policies
- **Single-node cluster** — Minikube simulates a cluster but runs on one machine
- **Manual secrets management** — No Vault or Sealed Secrets integration yet

---

## 🔮 Future Improvements

- [ ] **kube-state-metrics** — Richer cluster-level monitoring
- [ ] **CLI tool** — Dynamic app onboarding without editing YAML manually
- [ ] **Cloud deployment** — Port the setup to EKS or GKE
- [ ] **Logging stack** — Integrate Loki + Promtail or the ELK stack
- [ ] **RBAC & namespace isolation** — Basic multi-tenancy model
- [ ] **Helm charts** — Replace raw manifests with parameterized Helm templates

---

## 🛠 Tech Stack

`Kubernetes` · `Docker` · `Minikube` · `GitHub Actions` · `Prometheus` · `Grafana` · `cAdvisor` · `NGINX Ingress` · `Bash` · `WSL`

---

> **Note:** This project was built for learning purposes to understand Kubernetes, CI/CD, and observability concepts in a local environment. All claims are scoped to what the system actually does.
