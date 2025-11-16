# Level 3 – Tests Performed

## 1. Verified impersonation in Terraform output
Checked terraform apply output for:
"impersonating terraform-deployer@..."

## 2. Checked Cloud Audit Logs
Filtered by:
protoPayload.authenticationInfo.principalEmail="terraform-deployer@..."

Confirmed that GCP API calls were made by the impersonated GSA.

## 3. Checked Terraform provider identity
Ran:
terraform providers
Verified impersonated GSA is in the output.

## 4. Tested cluster access using Terraform identity
terraform plan and terraform apply both succeeded when impersonation enabled.

## 5. Confirmed no service account keys were created or stored
Validated security compliance goal achieved: keyless authentication.
