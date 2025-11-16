# Level 6 – Challenges and Fixes

## Challenge 1 – Existing identity pool had wrong assertion.repository
Fix:
- Set attributeCondition to `assertion.sub != ''` to remove repo restrictions.

## Challenge 2 – “Identity Pool does not exist” error
Cause:
- Used project ID instead of project number.
Fix:
- Reran command with projectNumber.

## Challenge 3 – GitHub Actions hanging on terraform plan
Cause:
- Terraform needed user input for variables.
Fix:
- Added -input=false and passed vars.

## Challenge 4 – Terraform fmt check failing
Fix:
- Ran terraform fmt locally, committed formatted file.

## Challenge 5 – Unsure where to specify GitHub repo in provider
Fix:
- Learned repo restriction is optional and comes in Level 7.
- Provider creation needs no username or repo.

## Challenge 6 – Clearing attribute conditions was rejected
Cause:
- GCP requires referencing a claim.
Fix:
- Used valid always-true expression referencing `assertion.sub`.

## Challenge 7 – Why do we need OIDC at all?
Fix:
- Understood that OIDC removes JSON keys and increases security,
  used in financial institutions for compliance.
