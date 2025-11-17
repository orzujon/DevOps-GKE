# Level 8 – Terraform Apply on Merge (Full Infra CI/CD)

This level implemented automated Terraform Apply triggered on every merge to
the main branch. GitHub Actions now authenticates to Google Cloud through OIDC
and performs a secure, keyless `terraform apply -auto-approve`.

The CI service account (github-ci) uses Workload Identity Federation and has
only the permissions required to apply infrastructure. Local Terraform uses my
gcloud identity, while CI uses OIDC — no impersonation or key files needed.

This level created a complete, production-style Infrastructure CI/CD pipeline:
- PR → Terraform fmt, validate, plan  
- Merge to main → Terraform apply  
Same pattern used by banks and top tech companies.
