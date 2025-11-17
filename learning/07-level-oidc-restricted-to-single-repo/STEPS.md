# Level 7 – Steps Executed

## 1. Identified the correct GitHub repository
- Username: orzujon
- Repository: DevOps-GKE

## 2. Updated the OIDC provider attribute condition
gcloud iam workload-identity-pools providers update-oidc github-provider \
  --location=global \
  --workload-identity-pool=github-pool \
  --attribute-condition="assertion.repository=='orzujon/DevOps-GKE'"

## 3. Verified the provider condition
gcloud iam workload-identity-pools providers describe github-provider \
  --location=global \
  --workload-identity-pool=github-pool \
  --format="value(attributeCondition)"

(Expected: assertion.repository=='orzujon/DevOps-GKE')

## 4. Confirmed GitHub workflow permissions
- Ensured workflow still had:
  permissions:
    id-token: write
    contents: read

## 5. Triggered workflow via pull request
- Pushed a small change.
- Opened a PR against main.
- Observed Terraform Plan job running with OIDC.
