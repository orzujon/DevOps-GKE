# Level 4 – Workload Identity (KSA ↔ GSA Binding)

In this level I learned how to give Kubernetes pods a Google Cloud identity
without using any service account keys. I understood the difference between
Kubernetes Service Accounts (KSA) and Google Service Accounts (GSA) and why
applications cannot talk to Google Cloud APIs by default.

Workload Identity lets pods impersonate a GSA securely. This enabled me to
run an application in GKE that could authenticate to GCP services such as
BigQuery, GCS, Pub/Sub or Secret Manager — all without storing credentials.

This level is essential for building a secure multi-tenant Platform-as-a-Service
because each namespace or team can have isolated cloud permissions.
