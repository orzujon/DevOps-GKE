# Level 7 – Challenges and Fixes

## Challenge 1 – Confusion about where repo is referenced
- Initially thought repo had to be passed during provider creation.
- Learned that repository restriction is done via attributeCondition.

## Challenge 2 – Existing provider already had a condition
- Needed to modify, not recreate, to avoid breaking other pieces.
- Resolved by replacing with a clean assertion.repository condition.

## Challenge 3 – Risk of locking myself out
- Concern that a wrong condition would break CI auth.
- Mitigated by testing immediately with a PR after the change.
