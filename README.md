# DevOps-GKE
Building an infrastructure

Prerequisite for this infra to work: Level 2 

Your laptop / repo
┌───────────────────────────────────────────────┐
│ infra/                                        │
│   terraform/                                  │
│     providers.tf    → defines providers       │
│     main.tf         → says: install this      |
|     variables.tf    → vars for the env        |
│     values/web.yaml → settings (CPU, mem)     │
│     charts/hello/   → your OWN Helm chart     │
└───────────────────────────────────────────────┘

        terraform apply
               │
               ▼
       Terraform Helm provider
               │
               ▼
         GKE API (cluster)
               │
               ▼
       Pods + Service in namespace



🔥 LEVEL 3 — The Service Account Forge

- IAM + Terraform + Kubernetes integration
- service account design
- safe authentication
- least privilege
- workload identity

These are core pillars in every Platform Engineer / DevOps interview.

Level 3 Goal

Create a Google Cloud Service Account for Terraform-managed deployments, give it minimal IAM, and use it inside your Terraform code.

Visual overview first:

You                    Terraform               Google Cloud            GKE Cluster
┌───────────┐         ┌───────────┐           ┌─────────────────┐     ┌─────────────┐
│ PowerShell│  plan → │ providers │   auth →  │ GCP Service     │     │   K8s API   │
│ terraform │ apply → │  (helm,k8s)│  via SA  │ Account (GSA)   │ --> │ deployments │
└───────────┘         └───────────┘           └─────────────────┘     └─────────────┘


We will NOT use keys (JSON files).
We will use gcloud auth with impersonation (interview-grade technique).




🔥 STEP 1 — Create the Service Account (GSA)
In PowerShell:
$PROJECT = "<your-project>"

gcloud iam service-accounts create terraform-deployer `
  --description="Terraform deployer for GKE" `
  --display-name="terraform-deployer"


Verify:

gcloud iam service-accounts list --project $PROJECT


You should see:

terraform-deployer@<your-project>.iam.gserviceaccount.com


We'll call this:

$SA_EMAIL="terraform-deployer@<your-project>.iam.gserviceaccount.com"



🔥 STEP 2 — Grant minimum IAM

For Terraform to deploy into GKE (Helm → K8s API), it needs:

A) Permission to connect to GKE:
roles/container.clusterViewer

B) Permission to interact with Kubernetes API:

GKE uses RBAC internally → no IAM needed.
Your kubeconfig gives cluster access, NOT IAM.

C) Permission to read cluster metadata (needed by helm/kubernetes provider):
roles/container.developer                      #    We need to find a link to see what does this role do - what permissions does it have

D) Optional: IAM for future steps (not used yet):
roles/iam.serviceAccountUser                   #    We need to find a link to see what does this role do - what permissions does it have


Let’s assign minimal ones now:      

gcloud projects add-iam-policy-binding $PROJECT `
  --member "serviceAccount:$SA_EMAIL" `
  --role "roles/container.clusterViewer"

gcloud projects add-iam-policy-binding $PROJECT `
  --member "serviceAccount:$SA_EMAIL" `
  --role "roles/container.developer"


  🔥 STEP 3 — Allow you to impersonate this SA

(so terraform uses this SA without keys)

$USER="<your-gke-email>"

gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL `
  --member="user:$USER" `
  --role="roles/iam.serviceAccountTokenCreator"


Meaning:

You (your Google account) are allowed to impersonate the service account.


🔥 STEP 4 — Update Terraform to use SA impersonation

Update your providers.tf → change Google provider block:

Before:
provider "google" {
  project = var.project_id
  region  = var.region
}

After (with impersonation):
provider "google" {
  project = var.project_id
  region  = var.region

  impersonate_service_account = "terraform-deployer@<your-project>.iam.gserviceaccount.com"
}


This means:

Terraform uses your gcloud login to impersonate the GSA.
No keys. No secrets. Enterprise-safe.