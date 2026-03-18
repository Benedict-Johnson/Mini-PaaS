# 🧠 Mini-PaaS: A Self-Hosted Platform-as-a-Service Built with Docker, NGINX, and Linux

> A simplified cloud deployment platform built from scratch to understand the core infrastructure behind modern cloud services.

The system automates **container deployment**, **reverse proxy routing**, **domain mapping**, **monitoring**, and **logging**.

---

## 🏗️ System Architecture
```
                🌐 Browser
                     │
                     ▼
              NGINX Reverse Proxy
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
   Docker Container          Docker Container
        │                         │
       App1                     App2 / App3
        │                         │
        └──────────────┬──────────┘
                       ▼
                   Docker Engine
                       │
        ┌──────────────┴──────────────┐
        ▼                              ▼
     cAdvisor                     Prometheus
        │                              │
        └──────────────► Grafana ◄─────┘
                    Monitoring Dashboard
```

---

## ⚙️ Features

### 🚀 Application Deployment

Deploy containerized applications with a single command:
```bash
./deploy.sh <app-name>
```

The script automatically:
- Builds the Docker image
- Finds an available port
- Runs the container
- Configures the NGINX reverse proxy
- Reloads NGINX

**Deployment in action:**

<img width="1428" height="877" alt="deploy script output" src="https://github.com/user-attachments/assets/0cce2534-1337-40ae-bd58-9a872b1cad83" />

---

### 🌐 Reverse Proxy Routing

Apps are accessible via clean domains instead of raw ports:
```
http://app1.local
http://app2.local
http://app3.local
```

Handled via NGINX reverse proxy.

**Live app served at `app3.local`:**

<img width="538" height="122" alt="docker ps output" src="https://github.com/user-attachments/assets/6f33d67c-5724-41c7-b0c0-f4102e5338ab" />

---

### 🐳 Dockerized Applications

Each application runs in an isolated Docker container.

**Benefits:**
- Environment isolation
- Reproducible builds
- Easy scaling

**Running containers (`docker ps`):**

<img width="588" height="397" alt="app3.local in browser" src="https://github.com/user-attachments/assets/ac7df96c-961f-4fe8-a989-f35467c252c7" />

---

### 📊 Monitoring Stack

| Tool | Purpose |
|------|---------|
| cAdvisor | Container metrics |
| Prometheus | Metrics collection |
| Grafana | Visualization dashboards |

**Available metrics:**
- Container CPU usage
- Memory usage
- Container uptime
- Resource monitoring

---

### 📁 Per-Application Logs

Each deployed application has its own log directory:
```
logs/app1
logs/app2
logs/app3
```

---

### 🔒 Security

Basic security hardening implemented:
- Firewall via UFW
- Container restart policies
- Health checks
- Isolated containers

---

## 📂 Project Structure
```
mini-paas/
│
├── app1/
│   ├── Dockerfile
│   └── index.html
│
├── app2/
│   ├── Dockerfile
│   └── index.html
│
├── app3/
│   ├── Dockerfile
│   └── index.html
│
├── monitoring/
│   ├── docker-compose.yml
│   └── prometheus.yml
│
├── logs/
├── deploy.sh
├── .gitignore
└── README.md
```

---

## 🛠️ Technologies Used

| Technology | Role |
|-----------|------|
| Linux (WSL2 Ubuntu) | Host environment |
| Docker | Container runtime |
| NGINX | Reverse proxy |
| Bash | Deployment automation |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboard |
| cAdvisor | Docker metrics exporter |

---

## 🚀 How to Deploy an App

**1️⃣ Create an app folder**
```bash
mkdir app4
```

**2️⃣ Add your files**

`Dockerfile`
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

`index.html` — your app's HTML content

**3️⃣ Deploy**
```bash
./deploy.sh app4
```

**4️⃣ Access in browser**
```
http://app4.local
```

---

## 📊 Monitoring

Start the monitoring stack:
```bash
docker compose up -d
```

| Service | URL |
|---------|-----|
| Grafana | http://localhost:3000 |
| Prometheus | http://localhost:9090 |
| cAdvisor | http://localhost:8082 |

> **Default Grafana login** — Username: `admin` / Password: `admin`  
> ⚠️ Password was changed by the author.
<img width="1538" height="897" alt="image" src="https://github.com/user-attachments/assets/940498d8-f347-4368-af48-4cc009ba5c31" />

---

## 🎯 What This Project Demonstrates

- Linux systems administration
- Containerization with Docker
- Reverse proxy configuration
- Infrastructure automation with Bash
- Observability and monitoring systems
- DevOps fundamentals

---

## 📝 A Note on the Frontend

Since the primary focus of this project is understanding **hosting infrastructure** — container orchestration, reverse proxy routing, deployment automation, and observability — very little attention was given to the `index.html` files served by each app.

The pages are intentionally bland and minimal; they exist purely as placeholder apps to validate that:
- Containers are running correctly
- NGINX is routing traffic to the right service
- The deployment pipeline works end-to-end

In a real-world PaaS, the hosted application's frontend would be entirely up to the developer deploying it. The platform's job is just to serve it reliably. 🚀

---

## 📌 Future Improvements

- [ ] Automatic SSL via Let's Encrypt
- [ ] Dynamic DNS routing
- [ ] Container orchestration
- [ ] Auto scaling
- [ ] Deployment dashboard UI
- [ ] Kubernetes integration

---

## 📜 License

This project is for educational and demonstration purposes.
