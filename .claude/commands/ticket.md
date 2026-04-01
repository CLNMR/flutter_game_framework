---
description: Interactive issue creation. Type, description, labels, milestone, template.
---

# Ticket

Interactively create a GitHub issue for univelop/univelop.

## Process

### 1. Choose issue type

Ask the user:

- **Bug report** (label: `bug`)
- **Feature request** (label: `enhancement`)
- **Refactoring request** (label: `refactoring`)

### 2. Gather information

**Bug report:**
- What happened? (required)
- URL to reproduce
- Invitation link (if applicable)
- Version: App/Prod, Next, or Dev (required)
- Client: Browser, iOS, or Android (required)
- Implementation approach
- Customer comment

**Feature request:**
- Description (required)
- Implementation approach
- Mock-up or UI description
- Timeline
- Customer comment

**Refactoring request:**
- Description (required)
- Implementation approach
- Timeline

### 3. Labels

Ask which labels to apply. Common choices:
- Project: `📂 Univelop`, customer-specific labels
- Team: Ganymed, Luna
- Status: `🚧 WIP`

Use `gh label list` if the user is unsure.

### 4. Milestone (optional)

Ask if they want to assign a milestone. List available ones with `gh api repos/univelop/univelop/milestones --jq '.[].title'` if needed.

### 5. Confirm and create

Show the composed title and body. After user confirms:

```bash
gh issue create --title "TITLE" --label "label1,label2" --body "BODY"
```

### 6. Post-creation

Show the issue URL. Remind the user to set priority and sprint.
