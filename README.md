🌐 Terraform + Kubernetes End-to-End Test mit GitHub Actions

Dieses Projekt enthält eine vollständige E2E-Testpipeline für eine Kubernetes-Anwendung, die mithilfe von Terraform, Kind, GitHub Actions und Ingress NGINX automatisiert bereitgestellt und getestet wird.

⸻

📦 Was wird bereitgestellt?

Beim Ausführen dieser Pipeline wird folgende Infrastruktur in einem lokalen Kubernetes-Cluster (Kind) aufgebaut:
	•	🔧 Ein Namespace demo
	•	🧠 Ein ConfigMap mit HTML-Inhalt (index.html)
	•	🔐 Ein Secret mit einem Passwortwert
	•	🚀 Ein Deployment (nginx) mit 2 Replikas basierend auf nginx:1.25
	•	📡 Ein NodePort-Service (nginx-service) für den Zugriff auf Port 80
	•	📈 Eine Horizontal Pod Autoscaler (HPA) auf Basis von CPU-Auslastung
	•	🌐 Ein Ingress mit Host nginx-demo.local für den externen Zugriff
	•	💾 Ein PersistentVolume (hostPath) und ein dazugehöriger PVC (demo-pvc)

⸻

🔬 Welche Tests werden durchgeführt?

Jede Änderung (Push oder Pull Request) gegen den main-Branch führt zu einer GitHub Actions Pipeline mit folgenden Schritten:

🔨 Provisionierung (Setup)
	•	Erstellung eines lokalen Kind-Clusters
	•	Installation von kubectl & kind
	•	Labeln des Knotens mit ingress-ready=true (für NGINX)
	•	Erstellung von PV/PVC mit manuellem StorageClass
	•	Einrichtung des Terraform CLI

📦 Terraform Deployment
	•	terraform init, validate, plan, apply
	•	Erstellung aller Ressourcen im Namespace demo

✅ Funktionale Tests
	•	Warten auf PVC → Status Bound
	•	Warten auf nginx-demo Deployment Rollout
	•	Zugriff über Port-Forward auf nginx-service
	•	Ingress-Test über Host nginx-demo.local
	•	Ausgabeprüfung auf HTML-Inhalt: K8s Demo via Terraform

🧹 Cleanup
	•	terraform destroy zur Entfernung aller Ressourcen
	•	Entfernen des Clusters über kind delete cluster

⸻

⚙️ Voraussetzungen
	•	Ein GitHub-Repository mit folgenden Dateien:
	•	main.tf: Terraform-Konfiguration für Kubernetes-Ressourcen
	•	.github/workflows/e2e.yml: CI-Workflow mit Kind + Terraform
	•	Secrets in GitHub Actions:
	•	DEMO_PASSWORD (wird in das Secret geschrieben)

⸻

▶️ Verwendung
	1.	Forke dieses Repository
	2.	Aktiviere GitHub Actions
	3.	Pushe eine Änderung oder öffne einen Pull Request gegen main
	4.	Die CI-Pipeline wird automatisch ausgeführt

Nach erfolgreichem Lauf kannst du sicher sein, dass dein Deployment vollständig und korrekt funktioniert – inklusive Storage, Services, Ingress und Skalierung (HPA).

⸻

📌 Hinweise
	•	Der Cluster ist temporär und nur für CI-Zwecke geeignet
	•	Es wird keine externe Cloud verwendet – rein lokal mit kind
	•	storageClassName: manual wird verwendet, um Probleme mit Pending PVC zu vermeiden
	•	Ingress-Deployment wird automatisch gepatcht (kein hostPort)

⸻

🛠 Weiterentwicklungsideen
	•	Migration auf echten Cloud-Provider (EKS, GKE)
	•	HTTPS/TLS über cert-manager
	•	Integration mit Helm oder ArgoCD (GitOps)
	•	Tests mit k6, Postman oder End-to-End via Cypress

⸻

📄 Erstellt mit ❤️ und Automatisierung für robuste Infrastrukturtests.
