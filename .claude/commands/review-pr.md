Review all changes on the current branch compared to master against the Univelop review rules.

## Instructions

1. First, read the review rules from `.claude/review-rules.md`.

2. Determine the current branch and get all changes compared to master:
   - `git diff master...HEAD` (all committed changes on this branch)
   - `git diff master...HEAD --name-only` (changed file list)
   - Also include any uncommitted changes: `git diff` and `git diff --cached`

3. If there are no changes compared to master, inform the user and stop.

4. Run `git log master..HEAD --oneline` to understand the commit history of this branch.

5. For each changed file, read the full file content to understand the context (not just the diff).

6. Apply ALL six rules from the review rules document against the changes:
   - Rule 1: New External Packages — compare `pubspec.yaml` on this branch vs master
   - Rule 2: Business Logic / UI Separation
   - Rule 3: Data Structure Changes
   - Rule 4: New Bricks AI Readiness
   - Rule 5: New Bricks MultiValue Principle
   - Rule 6: Public Interface Documentation

7. For Rule 6 (Documentation): ONLY check new or modified public members introduced on this branch — do not flag existing undocumented code that was not touched.

8. Output the review in the format defined in the rules document (Summary, Blockers, Errors, Warnings, Suggestions).

9. At the end, provide a **PR readiness verdict**:
   - **Ready to merge** — no blockers or errors found
   - **Needs fixes** — errors found that must be resolved
   - **Needs approval** — blockers found that require Jannis Rosenbaum's sign-off

10. After the review, ask: "Would you like me to fix any of these issues?"

## Important

- Be specific: always include file paths and line numbers.
- Be actionable: every finding must include a concrete fix suggestion.
- Be scoped: only review changes introduced on this branch, not pre-existing issues.
- Do NOT automatically fix anything — only suggest fixes and wait for confirmation.
