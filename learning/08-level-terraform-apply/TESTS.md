# Level 8 – Tests Performed

## 1. PR → Plan
- Confirmed Terraform CI workflow runs:
  - terraform fmt
  - terraform validate
  - terraform plan

## 2. Merge → Apply
Merged PR into main:
- OIDC authentication succeeded
- terraform init succeeded
- terraform apply -auto-approve deployed changes

## 3. Verify deployment
Checked:
- kubectl get pods
- kubectl get svc
- helm releases

## 4. Identity test
Verified:
- Local runs use my user IAM identity via gcloud.
- CI runs use github-ci identity via OIDC.
- No JSON keys used at any stage.

## 5. End-to-end test
Full flow worked:
Feature branch → PR → Plan → Merge → Apply → Infra updated.
