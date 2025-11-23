# Level 9 – Questions I Asked

### Q1. Why didn’t Terraform recreate the KSA after deleting the namespace?

Because the KSA was not originally defined in Terraform.  
Terraform only manages and recreates resources that are declared in .tf files and tracked in state.

### Q2. Why is Workload Identity needed?

Workload Identity allows pods to:

- Use a Kubernetes ServiceAccount (KSA)
- Map that KSA to a Google ServiceAccount (GSA)
- Access Google Cloud APIs *without* storing or managing JSON key files

It is the secure, recommended way to authenticate workloads running on GKE.

### Q3. Why did Terraform need admin-level IAM roles?

Because Terraform modifies identity-related policies:

- To modify GSA IAM policies, it needs:
  - roles/iam.serviceAccountAdmin
- To modify project IAM bindings, it needs:
  - roles/resourcemanager.projectIamAdmin

Without these, Terraform receives 403 errors when applying IAM changes.


### Q4. Why did Helm end up using the wrong serviceAccountName?

Because values.yaml contained:

- serviceAccountName: app-${var.environment}-ksa

Helm does not interpret Terraform variables; it just forwards that literal string to Kubernetes.
This caused Kubernetes to reject the value.
The fix was to clear the value in values.yaml and let Terraform set the correct name via set { ... }.


### Q5. Why move from kubeconfig to GKE endpoint + token?

Because:
	•	GitHub Actions runners do not have your local kubeconfig.
	•	Token-based provider configuration:
	•	Works locally (via gcloud auth)
	•	Works in CI (via OIDC & google_client_config)
	•	This makes the setup CI/CD-friendly and more portable.