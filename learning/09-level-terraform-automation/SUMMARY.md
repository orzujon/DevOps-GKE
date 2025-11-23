# Level 9 – Terraform-managed Workload Identity model 

Move from a partially manual identity setup to a fully automated, Terraform-managed Workload Identity model.

This includes:
Creating a namespace per environment
Creating a Kubernetes Service Account (KSA)
Creating a Google Service Account (GSA)
Binding KSA ↔ GSA through Workload Identity
Wiring Helm release to use that KSA
Ensuring GitHub Actions can deploy without kubeconfig
Fixing IAM permissions so Terraform can manage everything end-to-end




Final Architecture for DEV Environment

GCP Project (dev)
│
├── GKE Cluster (autopilot)
│    │
│    ├── Namespace: app-dev
│    │     │
│    │     ├── KSA: app-dev-ksa
│    │     │     └── annotation → app-dev-gsa@project.iam.gserviceaccount.com
│    │     │
│    │     ├── Deployment (hello-app)
│    │     └── Service
│    │
│    └── Workload Identity enabled
│
└── GSA: app-dev-gsa
      ├── roles/storage.objectViewer
      └── iam.workloadIdentityUser ← bound to KSA



Resources Fully Managed by Terraform (after Level 9)

Terraform now manages:
- Namespace
- KSA
- GSA
- GSA IAM roles
- Workload Identity binding
- Helm release
- K8s Deployment & Service
- Identity wiring end-to-end



