---
description: Full situational awareness — sprint board, branches, worktrees, uncommitted changes, last checkpoint. Run at session start.
---

# Status

## Arguments

$ARGUMENTS

## Execution

Run all checks in parallel. Gather everything, then render output once.

### 1. Jira Sprint

If `.env` has `JIRA_URL`:
```
mcp__atlassian__jira_get_agile_boards(project_key=<from .uatu/config/project.md>)
→ mcp__atlassian__jira_get_sprints_from_board(board_id, state="active")
→ mcp__atlassian__jira_get_sprint_issues(sprint_id)
```
Group by status: In Progress, To Do, Done (count only).

### 2. Git State
```bash
git branch --show-current
git status --short
git log --oneline -5
git stash list
```

### 3. Worktrees
```bash
git worktree list
```
Flag any worktree with no commits in the last 3 days as stale.

### 4. Last Checkpoint

Read the most recent entry from `.uatu/delivery/checkpoints/sessions.jsonl`.
Extract: timestamp, what was worked on, remaining tasks.

### 5. Time This Week

If `~/.uatu/time-tracking/worklog.jsonl` exists, sum hours for the current project this week.

---

## Output Format

Render as clean markdown. One section per block, no ASCII borders.

```
## [Project Name] · [current branch]
[date] [time]

### Sprint: [Sprint Name]  (ends [date])
| | Tickets |
|---|---|
| In Progress | [KEY] [summary] · [KEY] [summary] |
| To Do | [KEY] [summary] · [KEY] [summary] |
| Done | [N] completed |

### Git
- Branch: [branch]  [N commits ahead of main]
- Uncommitted: [list files, or "clean"]
- Stash: [N entries, or "empty"]

### Worktrees
- [path]  ← current
- [path]  (active)
- [path]  ⚠ stale

### Last Session
[date] — [one-line summary]
Remaining: [tasks]

### Time This Week
[Xh Ym] on [project]
```

**Rules:**
- If Jira is not configured, skip Sprint section entirely (no placeholder)
- If no worktrees, skip Worktrees section
- If no checkpoint exists, skip Last Session section
- Keep each section tight — no empty rows, no "N/A" entries

---

## `--all` Flag

Show status across all projects with `.uatu/` installed:
```bash
find ~/Workspace -name ".uatu" -type d -maxdepth 4
```

For each project, one compact line:
```
[project]  [branch]  [uncommitted count]  [last checkpoint date]  [time this week]
```
