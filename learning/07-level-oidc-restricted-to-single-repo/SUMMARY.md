# Level 7 – OIDC Restricted to Single GitHub Repository

In this level I locked down my Workload Identity Provider so that only my
GitHub repository (orzujon/DevOps-GKE) can authenticate to Google Cloud.

Before this, the identity provider could accept tokens from any GitHub repo.
After this change, only workflows coming from my specific repository are
trusted. This is how real enterprises secure their CI/CD identity paths.
