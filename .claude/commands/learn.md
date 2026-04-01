Analyse recent work for mistakes, inefficiencies, or missing knowledge and update CLAUDE.md files and skills.

## Instructions

1. **Identify the scope.** Review the conversation history (or `git diff` if no conversation context) to find all code changes made in this session.

2. **Categorise mistakes.** For each change, ask:
   - Did I use a low-level API when a higher-level service/abstraction existed?
   - Did I have to discover a pattern through trial-and-error that should have been documented?
   - Did I misuse a class, use the wrong import, or bypass a convention?
   - Did I need multiple research rounds for something that a one-liner in CLAUDE.md would have resolved?

3. **Filter for durable value.** Only capture learnings that:
   - Apply to future tasks (not just this one-off fix).
   - Are NOT already documented in CLAUDE.md files, skills, or obvious from reading the code.
   - Are about *which abstraction to reach for*, not implementation details that change.

4. **Decide where the learning belongs:**
   - **Package CLAUDE.md** — conventions, preferred APIs, "use X not Y" rules that apply broadly within the package.
   - **Skill SKILL.md** — pattern-level guidance (e.g., "when building a brick, do X"). Create a new skill only if the pattern recurs across multiple tasks.
   - **Root CLAUDE.md** — cross-cutting rules that apply to the entire repo.

5. **Apply the updates.**
   - Read the target file first.
   - Add the learning in the appropriate section (create a new section if needed).
   - Keep entries concise: one line per rule, with a brief "why" if non-obvious.
   - Do NOT duplicate information already present.

6. **Verify.** Re-read updated files to confirm the additions are correct and well-placed.

7. **Summarise.** Print a short table of what was learned and where it was saved:
   ```
   | Learning | File |
   |----------|------|
   | Use RecordService over stateSnap.db | packages/uni_core/CLAUDE.md |
   ```
