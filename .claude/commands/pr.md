---
description: Creates PR from branch. Auto-detects issue number. Fills template.
---

# PR

Create a pull request from the current branch.

## Process

### 1. Gather context

Run in parallel:
- `git status`
- `git log --oneline master..HEAD`
- `git diff master...HEAD --stat`
- `git branch --show-current`
- Check if branch is pushed to remote

### 2. Detect issue number

Extract from branch name (convention: `{issue-number}-short-description`). If not found, ask the user.

Fetch issue details:

```bash
gh issue view ISSUE_NUMBER --json title,body,labels
```

### 3. Target branch

Default: `master`. Ask if they want a different target (beta, release).

### 4. Compose PR

Title follows conventional commits based on issue type:
- Bug → `fix: description`
- Enhancement → `feat: description`
- Refactoring → `refactor: description`

Keep title under 70 characters.

Body uses the template from `.github/pull_request_template.md` with `{ticket}` replaced by the issue number.

### 5. Confirm and create

Show the title to the user. After confirmation:

```bash
git push -u origin BRANCH_NAME

gh pr create --title "TITLE" --body "$(cat <<'EOF'
BODY
EOF
)" --base TARGET_BRANCH
```

### 6. Post-creation

Show the PR URL. Remind the user to:
- Comment `/claude-review` for Claude Code Review
- Request code reviews from team members
- Add code owners as reviewers for new files
