# Level 6 – GitHub → GCP OIDC (Keyless Terraform Authentication)

In this level I implemented Workload Identity Federation between GitHub Actions
and Google Cloud. This allows CI to authenticate to GCP without using JSON
service account keys. Terraform plan now runs securely inside GitHub Actions
via temporary credentials issued by GCP.

This is enterprise-grade authentication used by banks, fintech, and large
engineering teams. I learned how identity pools, providers, and service account
impersonation work together, and how GitHub’s OIDC token becomes a short-lived
Google access token.
