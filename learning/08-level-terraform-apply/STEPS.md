# Level 8 – Steps Executed

## 1. Gave the github-ci service account editor permissions
Temporarily granted permissions needed to manage GKE resources:

gcloud projects add-iam-policy-binding $PROJECT \
  --member="serviceAccount:github-ci@$PROJECT.iam.gserviceaccount.com" \
  --role="roles/editor"

## 2. Created terraform-apply workflow for main branch
Added .github/workflows/terraform-apply.yml that:
- Authenticates to GCP via OIDC
- Runs terraform init
- Runs terraform apply -auto-approve
- Triggers only on merges to main

## 3. Fixed Terraform variables in CI
Added -input=false and passed variables explicitly to avoid Terraform waiting
for interactive input inside GitHub Actions. Added -auto-approve for the input 
"yes" to be satisfied 

## 4. Removed kubeconfig dependency
Updated providers.tf to use:
- data.google_container_cluster
- data.google_client_config
- kubernetes/helm providers using endpoint + CA cert + token

This made Terraform work inside CI without relying on ~/.kube/config.

## 5. Removed impersonate_service_account for CI consistency
Impersonation from Level 3 caused conflicts in Level 8.
Cleaned up google provider to:

provider "google" {
  project = var.project_id
  region  = var.region
}

Local Terraform now uses user credentials.
CI Terraform uses OIDC identity.

## 6. Tested infrastructure apply
- Opened PR → Terraform Plan workflow ran successfully.
- Merged PR → Terraform Apply workflow deployed changes automatically.
