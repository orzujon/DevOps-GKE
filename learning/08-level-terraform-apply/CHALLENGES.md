# Level 8 – Challenges and Fixes

## Challenge 1 – Terraform stuck in CI
Cause: Terraform waiting for user input.
Fix: Added -input=false and passed all required vars.

## Challenge 2 – Runner missing kubeconfig
Cause: GitHub Actions runner starts clean with no ~/.kube/config.
Fix: Replaced all kubeconfig usage with dynamic cluster endpoint + access token.

## Challenge 3 – 403 iam.serviceAccounts.getAccessToken error
Cause: google provider still had impersonate_service_account from Level 3.
Fix: Removed impersonation to align with OIDC identity (github-ci).

## Challenge 4 – CI plan succeeded but CI apply failed
Cause: Different identity paths between plan and apply.
Fix: Unified provider config to be identity-agnostic.

## Challenge 5 – Keeping learning path and repo consistent
Fix: Kept Level 3 impersonation documented as learning,
but Level 6–8 use pure OIDC for real CI/CD.
