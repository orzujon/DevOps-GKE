# Level 5 – Tests Performed

## 1. CI workflow execution
- Opened a PR to main.
- Confirmed the "Terraform CI" workflow ran automatically.

## 2. Successful pipeline
- Ensured that with correct Terraform code:
  - terraform fmt -check passes.
  - terraform validate passes.
- PR showed green status.

## 3. Failed pipeline with broken code
- Introduced a syntax or formatting error in Terraform code.
- Pushed to branch and opened/updated PR.
- Confirmed "Terraform CI" failed and PR status was red.
- Confirmed main could not be merged with failing checks.

## 4. Branch protection behavior
- Tried to push directly to main (was blocked).
- Confirmed changes must go through a PR.
- Confirmed I could still merge via PR as repo admin with rules in place.
