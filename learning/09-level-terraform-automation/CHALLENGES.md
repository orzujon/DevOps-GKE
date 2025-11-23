# Level 9 – Challenges and Fixes

1. **Helm chart used a literal KSA name**
   - Problematic value in values.yaml:
     serviceAccountName: app-${var.environment}-ksa

   - Helm treated this as a literal string, not a Terraform expression.
   - Kubernetes rejected this as an invalid name:
     - Invalid value: "app-${var.environment}-ksa"

2. **GSA already existed (409 Conflict)**
   - A previous manual GSA creation caused Terraform to fail with:
     - Error 409: Service account ... already exists
   - Required deleting the manually created GSA once so Terraform could recreate and own it.

3. **Missing permission: iam.serviceAccounts.setIamPolicy**
   - Terraform could not attach Workload Identity bindings to the GSA.
   - Error:
     - Permission 'iam.serviceAccounts.setIamPolicy' denied
   - Fixed by granting:
     - roles/iam.serviceAccountAdmin to the identity running Terraform.

4. **Missing permission: resourcemanager.projects.setIamPolicy**
   - Terraform could not apply google_project_iam_member resources.
   - Error:
     - Policy update access denied
   - Fixed by granting:
     - roles/resourcemanager.projectIamAdmin to the identity running Terraform.

5. **Wrong Helm value key**
   - Terraform initially tried to use:
     - serviceAccount.name
   - But the chart actually used:
     - .Values.serviceAccountName in deployment.yaml
   - Fix:
     - Terraform now sets:
       set {
         name  = "serviceAccountName"
         value = kubernetes_service_account.app.metadata[0].name
       }

6. **Namespace deleted manually (kubectl delete ns app-dev)**
   - This removed:
     - KSA
     - Deployments
     - Services
   - But IAM and GSA remained.
   - Terraform did not recreate the KSA earlier because it wasn’t yet defined as a resource.
   - Fix:
     - KSA is now Terraform-managed, so it is recreated on apply.

7. **CI lacked kubeconfig**
   - GitHub Actions runner doesn’t have your local kubeconfig file.
   - Old provider config relying on kubeconfig broke CI.
   - Fix:
     - Token-based providers using GKE endpoint and google_client_config.

