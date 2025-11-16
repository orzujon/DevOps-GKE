# Level 6 – Steps Executed

## 1. Created CI Service Account
gcloud iam service-accounts create github-ci

## 2. Granted Viewer role (minimum permissions for plan)
gcloud projects add-iam-policy-binding ... roles/viewer

## 3. Verified pre-existing identity pool (github-pool)
Used:
- gcloud iam workload-identity-pools list
- gcloud iam workload-identity-pools describe github-pool

## 4. Inspected and modified the provider
- Discovered unwanted attributeCondition referencing old repo
- GCP refused empty/null condition
- Applied valid always-true condition:
  assertion.sub != ''

## 5. Fixed Workload Identity SA binding
- Discovered GCP needs project NUMBER, not ID
- Re-ran binding with correct projectNumber

## 6. Added GitHub Secrets:
- GCP_PROJECT_ID
- GCP_WI_PROVIDER
- Others optional later

## 7. Updated GitHub workflow with OIDC authentication
- Added google-github-actions/auth@v2
- Configured workload_identity_provider and service_account
- Set TF_WORKDIR=./terraform

## 8. Resolved Terraform hanging in CI
- Added -input=false
- Passed required variables through -var or defaults

## 9. Resolved Terraform fmt failure
- Ran terraform fmt locally
- Pushed corrected file
- CI passed

## 10. Merged PR to main
CI pipeline now handles Terraform plan via OIDC with no static keys.
