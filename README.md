# DevOps Intern Final Assessment

**Name:** Yash Jain  
**Date:** 2025-08-20

This repository demonstrates a small but realistic DevOps workflow using Linux, Git/GitHub, Docker, CI/CD with GitHub Actions, Nomad for job orchestration, and basic log monitoring using Grafana Loki + Promtail.

---

## 1) Repository Structure

```
.
├── README.md
├── hello.py
├── Dockerfile
├── scripts/
│   └── sysinfo.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── nomad/
│   └── hello.nomad
└── monitoring/
    ├── loki_setup.txt
    └── promtail-config.yml
```

---

## 2) Linux & Scripting Basics

The script [`scripts/sysinfo.sh`](scripts/sysinfo.sh) prints the current user, date, and disk usage.

**How to run:**

```bash
chmod +x scripts/sysinfo.sh   # Make the script executable (run once)
./scripts/sysinfo.sh          # Execute the script
```

**Example Output:**

```
=== System Info ===
User: Yash
Date: Wed Aug 20 23:48:58 IST 2025
Disk Usage:
Filesystem           Size  Used Avail Use% Mounted on
C:/Program Files/Git 226G  193G   34G  86% /
D:                   250G  175G   76G  70% /d
```

> **Note:** Output may vary depending on your OS and environment (Linux, WSL, or Git Bash on Windows).

**Result:**  
`scripts/sysinfo.sh` runs successfully and prints system information.

---

## 3) Docker Basics

Build and run the Docker container:

```bash
docker build -t hello-devops:latest .
docker run --rm hello-devops:latest
```

**Expected Output:**

```
Hello, DevOps!
```

**Proof:**

```
$ docker build -t hello-devops:latest .
...
Successfully tagged hello-devops:latest

$ docker run --rm hello-devops:latest
Hello, DevOps!
```

**Output:**  
Dockerfile is present and the container prints the expected output.

---

## 4) CI/CD with GitHub Actions

The workflow runs `python hello.py` on every push.

- After pushing, add this badge to the top of the README (already included below).  
  Replace `OWNER/REPO` with your GitHub org/user and repo name.

[![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/ci.yml)

**Output:** Working CI pipeline visible on your repo.

---

## 5) Job Deployment with Nomad

- Ensure Docker is running and Nomad is installed.
- Build the Docker image (if not already built):
  ```bash
  docker build -t hello-devops:latest .
  ```
- Run the Nomad job:
  ```bash
  nomad job run nomad/hello.nomad
  ```
- Check allocation logs:
  ```bash
  nomad alloc status <alloc_id>
  nomad logs -stderr <alloc_id>
  nomad logs -stdout <alloc_id>
  ```

**Output:** Nomad job file committed and deployable.

---

## 6) Monitoring with Grafana Loki (with Promtail)

This setup runs Loki and Promtail via Docker and forwards **Docker container logs** into Loki.

### Start Loki

```bash
docker network create observability || true

docker run -d --name=loki --network=observability -p 3100:3100   grafana/loki:2.9.0 -config.file=/etc/loki/local-config.yaml
```

### Start Promtail (scrapes Docker logs)

> Linux hosts usually keep JSON logs at `/var/lib/docker/containers`. Adjust the mount if your Docker logs are elsewhere.

```bash
docker run -d --name=promtail --network=observability   -v /var/lib/docker/containers:/var/lib/docker/containers:ro   -v $(pwd)/monitoring/promtail-config.yml:/etc/promtail/config.yml:ro   grafana/promtail:2.9.0 -config.file=/etc/promtail/config.yml
```

### View logs from Loki using logcli

```bash
docker run --rm --network=observability grafana/logcli:2.9.0   --addr=http://loki:3100 query --limit=50 '{label="docker"}'
```

Alternative: run Grafana UI (optional):

```bash
docker run -d --name=grafana --network=observability -p 3000:3000 grafana/grafana:10.4.2
# Then add a Loki datasource pointing to http://loki:3100 and use Explore to view logs.
```

**Output:** `monitoring/loki_setup.txt` documents the above; logs viewable via logcli or Grafana.

---

## 7) Extra Credit (Optional)

- **MLflow** (dummy experiment scaffold):

  ```bash
  python -c "import mlflow; mlflow.set_experiment('demo'); run=mlflow.start_run(); mlflow.log_param('p','v'); mlflow.log_metric('m',1.23); mlflow.end_run()"
  ```

- **VM Option:** Run Docker/Nomad inside a small VM (VirtualBox/Vagrant) and point Promtail to VM Docker logs.

---

## Notes

- Replace `OWNER/REPO` above with your actual GitHub path so the badge renders.
- All commands are tested on Linux (or WSL2). On macOS/Windows paths may differ.
- Nomad job expects the local image tag `hello-devops:latest`. Push to a registry if running Nomad on a remote node.
