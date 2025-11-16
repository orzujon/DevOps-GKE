# Level 6 – Tests Performed

## 1. GitHub → GCP Authentication Test
- Ran workflow on PR
- google-github-actions/auth successfully exchanged OIDC token for GCP token

## 2. Terraform Init Test
- terraform init succeeded inside GitHub runner

## 3. Terraform Plan Test
- terraform plan executed via CI using temporary credentials
- No hanging, full plan output visible in PR checks

## 4. Repository restriction disabled test
- Provider accepted OIDC token without rejecting it

## 5. Branch protection test
- CI enforced before merge into main

Everything worked after fixes.
