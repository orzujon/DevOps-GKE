# Level 9 – Workload Identity & Terraform Indentity Automation

## Steps Completed

1. **Created Terraform-managed namespace**
  - Namespace name pattern: 'app-${var.environment}'.
  - For dev, this becomes: 'app-dev'.

2.  **Created Terraform-managed Kubernetes ServiceAccount (KSA)**
  - Example KSA name: 'app-dev-ksa'.
  - Defined as a 'kubernetes_service_account' resource in Terraform.
  - No more manual 'kubectl create sa ...' for this account

3. **Created Terraform-managed Google ServiceAccount (GSA)**
  - Example GSA name: 'app-dev-gsa@<project-id>.iam.gserviceaccount.com'
  - Defined as a 'google_service_account' resource in Terraform
  - Terraform is now the single source of truth for this GSA. 

4. **Applied IAM roles to the GSA**
  - Granted roles like: 
    - 'roles/storage.objectViewer'
  - Attached via 'google_project_iam_member' so Terraform controls which GCP APIs the GSA can access. 

5. **Implemented Workload Identity binding (KSA ↔ GSA)**
   - Used google_service_account_iam_member with role:
     - roles/iam.workloadIdentityUser
   - Bound:
     - Kubernetes identity: serviceAccount:<project-id>.svc.id.goog[app-dev/app-dev-ksa]
     - To GSA: app-dev-gsa@<project-id>.iam.gserviceaccount.com
   - This allows pods using app-dev-ksa to act as the GSA without any keys.

6. **Fixed Helm chart serviceAccountName handling**
   - Removed the hard-coded value from charts/hello/values.yaml:
     serviceAccountName: app-${var.environment}-ksa
     
   - Replaced it with an empty or neutral value:
     serviceAccountName: ""
     
   - Let Terraform inject the real KSA name via the helm_release resource:
     set {
       name  = "serviceAccountName"
       value = kubernetes_service_account.app.metadata[0].name
     }

7. **Updated Terraform providers for CI-friendly auth**
   - Stopped using kubeconfig.
   - kubernetes and helm providers now use:
     - GKE endpoint from data.google_container_cluster
     - Token from data.google_client_config.default.access_token
     - Base64-decoded cluster CA certificate
   - This works both locally and inside GitHub Actions.

8. **Granted required IAM roles to the Terraform executor**
   - For service account policy management:
     - roles/iam.serviceAccountAdmin
   - For project IAM binding updates:
     - roles/resourcemanager.projectIamAdmin
   - Applied to:
     - Your user account for local runs
     - github-ci@<project-id>.iam.gserviceaccount.com for CI runs

9. **Successfully ran terraform apply**
   - Terraform now manages, end-to-end:
     - Namespace (app-dev)
     - KSA (app-dev-ksa)
     - GSA (app-dev-gsa@...)
     - GSA IAM roles
     - Workload Identity binding
     - Helm deployment using the correct KSA