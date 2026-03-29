---
description: Full situational awareness — sprint board, branches, worktrees, uncommitted changes, last checkpoint. Run at session start.
---

# Status

## Arguments

$ARGUMENTS

## Execution

Gather and present a complete status report. Run these checks in parallel where possible:

### 1. Jira Sprint Status

If Jira is configured (.env has JIRA_URL), fetch the active sprint:

```
mcp__atlassian__jira_get_agile_boards(project_key="<from .uatu/config/project.md>")
→ get board ID
→ mcp__atlassian__jira_get_sprints_from_board(board_id=<id>, state="active")
→ mcp__atlassian__jira_get_sprint_issues(sprint_id=<id>)
```

Group issues by status: To Do, In Progress, Done (this sprint).

### 2. Git State

```bash
git branch --show-current          # current branch
git status --short                 # uncommitted changes
git log --oneline -5               # recent commits
git stash list                     # any stashed work
```

### 3. Worktrees

```bash
git worktree list                  # all active worktrees
```

Flag any worktree with no commits in the last 3 days as "stale."

### 4. Last Checkpoint

Read the most recent entry from `.uatu/delivery/checkpoints/sessions.jsonl` (or latest `session-*.md`).
Show: timestamp, what was worked on, remaining tasks.

### 5. Time This Week

If `~/.uatu/time-tracking/worklog.jsonl` exists, show time spent this week on current project.

### Output Format

```
════════════════════════════════════════
        PROJECT STATUS — [Project Name]
════════════════════════════════════════

Sprint: [Sprint Name] (ends [date])
  In Progress: [KEY] [summary], [KEY] [summary]
  To Do: [KEY] [summary], [KEY] [summary]
  Done: [count] issues completed this sprint

Branch: [current branch]
  Uncommitted: [count] files ([list])
  Ahead of main: [count] commits

Worktrees:
  [path] (current)
  [path] ([status — active/stale])

Last Checkpoint: [timestamp]
  [summary of last session]

Time This Week: [hours]h [minutes]m
```

### If --all flag

Show status across all projects with `.uatu/` installed:
```bash
find ~/Workspace -name ".uatu" -type d -maxdepth 4
```

For each project: branch, uncommitted count, last checkpoint date, time this week.
