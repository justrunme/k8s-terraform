# ✅ Terraform + Kubernetes End-to-End Tests mit GitHub Actions

[![Terraform E2E Tests](https://github.com/justrunme/k8s-terraform/actions/workflows/terraform-e2e.yml/badge.svg)](https://github.com/justrunme/k8s-terraform/actions/workflows/terraform-e2e.yml)

Willkommen! Dieses Repository enthält eine vollständige E2E-Test-Pipeline für eine Kubernetes-Anwendung, die automatisiert mit Terraform, Kind, Ingress NGINX und GitHub Actions bereitgestellt und getestet wird.


---

🚀 Bereitgestellte Komponenten

📦 Beim Durchlauf der Pipeline wird in einem temporären Kubernetes-Cluster (kind) folgendes bereitgestellt:

🗂️ Namespace: demo

🔧 ConfigMap: HTML-Datei (index.html)

🔐 Secret: Mit DEMO_PASSWORD

🐳 Deployment: nginx (2 Replikas)

🌐 Service: nginx-service (NodePort)

📈 HorizontalPodAutoscaler (HPA): CPU-basiert

💾 PersistentVolume + PVC: manual StorageClass

🌍 Ingress: mit Host nginx-demo.local



---

🧪 Durchgeführte Tests

Jeder Commit und Pull Request auf main triggert folgende Tests in CI:

✅ Cluster Setup & CoreDNS verfügbar

✅ PV/PVC korrekt erstellt & Bound

✅ terraform init, validate, apply erfolgreich

✅ Rollout vom nginx-demo Deployment abgeschlossen

✅ Zugriff über NodePort (curl-Test)

✅ Zugriff über Ingress (curl-Test mit Host Header)

✅ Ressourcen-Cleanup (terraform destroy, kind delete)



---

⚙️ Voraussetzungen

GitHub Actions aktiviert

Folgende GitHub Secret-Variable:

DEMO_PASSWORD




---

📂 Struktur

.
├── main.tf                # Terraform Kubernetes-Konfiguration
├── variables.tf           # Eingabevariablen
└── .github/workflows/
    └── e2e.yml            # GitHub Actions Workflow für Tests


---

▶️ Verwendung

1. Forke dieses Repository


2. Lege das Secret DEMO_PASSWORD in den Repo-Einstellungen an


3. Push eine Änderung nach main oder öffne einen PR


4. Workflow wird automatisch ausgeführt ✅




---

💡 Warum Kind?

kind ermöglicht realitätsnahe Tests in CI/CD – ganz ohne echten Cloud-Cluster. Ideal für Pull Request Tests oder lokale Simulation.


---

📌 Hinweise

Cluster ist temporär (wird nach Tests gelöscht)

Es wird keine Cloud benötigt

hostPort-Konflikte im Ingress-Controller wurden gepatcht

StorageClass ist manuell gesetzt, um Pending PVC zu vermeiden

Ingress-NodeSelector wird via Label gesetzt: ingress-ready=true



---

🛠 Erweiterungsideen

🌐 HTTPS via cert-manager

🚢 Helm statt Terraform für Deployment

🔄 GitOps mit ArgoCD oder Flux

📊 Lasttests mit k6, API-Tests mit Postman



---

📄 Erstellt mit ❤️ für saubere, reproduzierbare Infrastruktur-Tests

