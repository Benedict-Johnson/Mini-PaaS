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

## 🏗 Architecture

```
GitHub Repository
      │
      ▼
GitHub Actions (CI/CD Trigger on Push)
      │
      ▼
Self-Hosted Runner (WSL on local machine)
      │
      ├── Builds Docker images
      ├── Applies Kubernetes manifests
      │
      ▼
Minikube Cluster
      │
      ├── Deployments (per app)
      ├── Services (ClusterIP)
      ├── Ingress (domain-based routing)
      ├── HPA (autoscaling)
      └── Monitoring namespace
            ├── Prometheus
            ├── Grafana
            └── cAdvisor + metrics-server
```

![Architecture Diagram](docs/images/architecture.png)
*↑ Replace with your architecture diagram*

---

## ⚙️ CI/CD Pipeline

The pipeline is triggered on every `push` to the repository.

**Flow:**
1. **Trigger** — Push to `main` kicks off the workflow
2. **Matrix Build** — Multiple apps are built in parallel using a job matrix
3. **Self-Hosted Runner** — A runner in WSL executes the deployment script locally
4. **Deploy Script** — Builds Docker images (via Minikube's Docker daemon) and applies `kubectl` manifests
5. **Rollout** — Kubernetes performs a rolling update automatically

<img width="537" height="432" alt="image" src="https://github.com/user-attachments/assets/47c5b673-fcdb-4b9a-bd07-0e6d31a610fb" />


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
4. deploy.sh builds Docker image using Minikube's daemon
   → docker build + kubectl apply -f k8s/apps/<app>/
         │
         ▼
5. Kubernetes performs rolling update
   → Old pods terminate gracefully
   → New pods pass readiness probes before serving traffic
```

---

## 📊 Monitoring

The monitoring stack runs in a dedicated `monitoring` namespace inside Minikube.

| Component | Role |
|---|---|
| **Prometheus** | Scrapes metrics from cAdvisor and app endpoints |
| **cAdvisor** | Exposes per-container CPU, memory, and network metrics |
| **metrics-server** | Provides resource metrics consumed by HPA |
| **Grafana** | Visualizes metrics via pre-configured dashboards |

![Grafana Dashboard](docs/images/grafana-dashboard.png)
*↑ Replace with your Grafana dashboard screenshot*

---

## 🖼 Screenshots

<summary>Kubernetes Cluster Output</summary>

<img width="1190" height="486" alt="image" src="https://github.com/user-attachments/assets/461f2670-a6fd-48ec-9182-ddd85a2a467f" />


<summary>App Routing via Ingress</summary>

![curl routing output](docs/images/curl-routing.png)

<summary>GitHub Actions — Successful Run</summary>

![GitHub Actions](docs/images/github-actions.png)

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

`Kubernetes` · `Minikube` · `Docker` · `GitHub Actions` · `Prometheus` · `Grafana` · `cAdvisor` · `NGINX Ingress` · `Bash` · `WSL`

---

> **Note:** This project was built for learning purposes to understand Kubernetes, CI/CD, and observability concepts in a local environment. All claims are scoped to what the system actually does.
