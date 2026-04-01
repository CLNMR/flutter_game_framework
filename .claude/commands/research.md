---
description: Spawns parallel sub-agents to investigate. Documents what exists.
model: opus
---

# Research Codebase

Document the codebase as it exists. Do not suggest improvements, critique the implementation, or propose changes. Describe what IS, not what SHOULD BE.

## Process

### 1. Read mentioned files

If the user mentions specific files, tickets, or docs, read them fully before spawning sub-tasks. Use Read without limit/offset parameters.

If no topic is provided, ask:

```
What area of the codebase should I research?
```

### 2. Decompose and research

Break the question into composable research areas. Spawn parallel Task agents:

- **code-finder** to locate files and components
- **code-analyzer** to understand how specific code works
- **code-pattern-finder** to find usage examples and patterns

For external documentation (only when needed):
- **web-researcher** for Flutter/Dart docs or API references

Remind all agents: document what exists, do not evaluate or suggest changes.

### 3. Synthesize

Wait for all agents to complete. Compile findings with file:line references. Connect components across packages.

### 4. Write research document

Run `.claude/scripts/get_metadata.sh` for metadata.

Write to `knowledge/shared/research/YYYY-MM-DD-description.md`:

```markdown
---
date: [ISO datetime with timezone]
repository: univelop
topic: "[Research Topic]"
tags: [research, codebase, component-names]
status: complete
last_updated: [YYYY-MM-DD]
---

# Research: [Topic]

## Research Question

[Original query]

## Summary

[High-level findings answering the question]

## Detailed Findings

### [Component/Area]

- What exists (file.ext:line)
- How it connects to other components
- Implementation details

## Code References

- `path/to/file.dart:123` - Description
- `another/file.dart:45-67` - Description

## Architecture

[Patterns, conventions, design decisions found]

## Historical Context

[Relevant findings from knowledge/ directory]

## Open Questions

[Areas needing further investigation]
```

### 5. Present and iterate

Show a concise summary to the user. If they have follow-up questions, append a `## Follow-up Research [timestamp]` section and update `last_updated` in frontmatter.
