---
description: At ~60% context. Writes task status, changes, learnings, next steps.
---

# Handoff

Write a handoff document to transfer work to another session. Compact and summarize your context without losing key details.

## Process

### 1. Gather metadata

Run `.claude/scripts/get_metadata.sh` to get current date, branch, commit hash.

### 2. Write the document

Save to `knowledge/local/scratch/handoffs/<branch>/YYYY-MM-DD_HH-MM-SS_description.md`:

```markdown
---
date: [ISO datetime with timezone]
git_commit: [current hash]
branch: [current branch]
repository: univelop
topic: "[Task Name] Implementation"
tags: [implementation, component-names]
last_updated: [YYYY-MM-DD]
---

# Handoff: <branch> — [concise description]

## Tasks

[Task descriptions with status: completed, in progress, or planned. Reference plan documents and research if applicable. Call out which phase you're on.]

## Critical References

[2-3 most important spec/design docs. Leave blank if none.]

## Recent Changes

[Changes made, in file:line syntax]

## Learnings

[Patterns, root causes, important context for whoever picks this up. Include file paths.]

## Artifacts

[Exhaustive list of produced/updated files as paths or file:line references]

## Next Steps

[Action items for the next session, ordered by priority]

## Notes

[Anything else: relevant codebase locations, references, tips]
```

### 3. Get approval

Ask the user to review. Apply changes if requested. Once confirmed, reply:

````
Handoff created. Resume in a new session with:

```
/resume-handoff knowledge/local/scratch/handoffs/<branch>/YYYY-MM-DD_HH-MM-SS_description.md
```
````

## Guidelines

- More information is better than less. This is a minimum template.
- Be thorough and precise: top-level objectives and lower-level details.
- Avoid large code snippets. Use file:line references that can be followed later.
