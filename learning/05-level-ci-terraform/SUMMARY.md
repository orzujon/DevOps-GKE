# Level 5 – Terraform CI and Branch Protection

In this level I learned how to add basic CI for Terraform using GitHub Actions
and how to protect the main branch so broken Terraform code cannot be merged.

The workflow runs `terraform fmt` and `terraform validate` on each push and
pull request to main. Branch protection ensures all changes go through a PR
and the CI workflow must be green before merging. This gives me a safer,
more professional workflow even as a solo developer.
