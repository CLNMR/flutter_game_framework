Review the current uncommitted changes against the Univelop review rules.

## Instructions

1. First, read the review rules from `.claude/review-rules.md`.

2. Get all current changes by running:
   - `git diff` (unstaged changes)
   - `git diff --cached` (staged changes)
   - `git diff --name-only` and `git diff --cached --name-only` (changed file list)

3. If there are no changes, inform the user and stop.

4. For each changed file, read the full file content to understand the context (not just the diff).

5. Apply ALL six rules from the review rules document against the changes:
   - Rule 1: New External Packages
   - Rule 2: Business Logic / UI Separation
   - Rule 3: Data Structure Changes
   - Rule 4: New Bricks AI Readiness
   - Rule 5: New Bricks MultiValue Principle
   - Rule 6: Public Interface Documentation

6. For Rule 6 (Documentation): ONLY check new or modified public members — do not flag existing undocumented code that was not touched.

7. Output the review in the format defined in the rules document (Summary, Blockers, Errors, Warnings, Suggestions).

8. If all rules pass, congratulate the developer and confirm the changes are ready.

9. After the review, ask: "Would you like me to fix any of these issues?"

## Important

- Be specific: always include file paths and line numbers.
- Be actionable: every finding must include a concrete fix suggestion.
- Be scoped: only review what changed, not the entire codebase.
- Do NOT automatically fix anything — only suggest fixes and wait for confirmation.
