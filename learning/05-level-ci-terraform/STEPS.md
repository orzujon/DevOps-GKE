# Level 5 – Steps Executed

## 1. Created Terraform CI workflow
Path: .github/workflows/terraform-ci.yml

Configured:
- Trigger on push and pull_request to main.
- Job runs on ubuntu-latest.
- Working directory set to ./terraform.
- Steps:
  - Checkout repo.
  - Setup Terraform (hashicorp/setup-terraform@v3).
  - Run `terraform fmt -check`.
  - Run `terraform init -backend=false`.
  - Run `terraform validate`.

## 2. Adjusted working directory for my repo
Changed workflow to use:
working-directory: ./terraform

## 3. Enabled branch protection on main
- Settings → Branches → Add rule for main.
- Require a pull request before merging.
- Require status checks to pass (Terraform CI).
- Block direct pushes to main.

## 4. Allowed admin bypass for myself
- Enabled "Allow administrators to bypass branch protection rules"
  so I can approve/merge my own PRs as the only maintainer.

## 5. Opened a feature branch and PR
- Created a branch, pushed changes, opened PR.
- CI ran automatically on the PR.

## 6. Verified that broken Terraform fails CI
- Intentionally broke formatting/validation to confirm CI blocked merge.
