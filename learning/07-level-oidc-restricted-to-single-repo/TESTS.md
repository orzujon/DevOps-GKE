# Level 7 – Tests Performed

## 1. Provider condition verification
- Described provider and confirmed:
  assertion.repository=='orzujon/DevOps-GKE'

## 2. Successful OIDC authentication from correct repo
- Opened a PR from orzujon/DevOps-GKE.
- Terraform Plan workflow authenticated and ran successfully.

## 3. Implicit security test
- Understood that if a different repo tried to use this provider,
  the attributeCondition would reject its token.

Level 7 confirmed that CI identity is now restricted to my GitHub repository.
