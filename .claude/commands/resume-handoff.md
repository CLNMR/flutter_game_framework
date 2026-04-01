---
description: Loads latest handoff. Validates assumptions against current codebase.
---

# Resume

Resume work from a handoff document. Validate that assumptions still hold against the current codebase.

## Process

### 1. Load the handoff

If a path was provided, read it fully. Otherwise list available handoffs and ask:

```
Which handoff should I resume from?

Tip: /resume-handoff knowledge/local/scratch/handoffs/<branch>/YYYY-MM-DD_HH-MM-SS_description.md
```

### 2. Set up the branch

Verify the current branch matches the handoff. If not:

```bash
git fetch origin <branch>
```

Check if the branch is already in a worktree:

```bash
git worktree list --porcelain | awk -v b="refs/heads/<branch>" '
/^worktree / { path = $2 }
$0 == "branch " b { print path; found=1; exit }
END { exit !found }
'
```

If found, cd to it. Otherwise create a worktree:

```bash
# If branch exists locally or on remote
git worktree add .claude/worktrees/<branch> <branch>
```

If the branch doesn't exist anywhere, tell the user.

### 3. Read context

Read the handoff fully, then read all linked artifacts:
- Plan documents from `knowledge/local/plans/` or `knowledge/shared/`
- Research documents
- Files mentioned in "Recent Changes" and "Learnings"

Spawn a **code-finder** agent to verify that key files still exist and haven't changed significantly since the handoff commit.

### 4. Present analysis

```
Resuming from handoff [date]:

Tasks:
- [Task]: [handoff status] → [current verification]

Learnings validated:
- [Learning with file:line] — [still valid / changed]

Recent changes:
- [Change] — [present / missing / modified]

Recommended next actions:
1. [First priority from handoff's next steps]
2. [Second priority]

Issues found:
- [Conflicts or regressions, if any]

Proceed with [action 1]?
```

### 5. Begin work

After confirmation, create a task list from the handoff's next steps and begin implementation. Reference learnings throughout.
