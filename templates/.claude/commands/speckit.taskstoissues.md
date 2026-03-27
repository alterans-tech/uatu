# speckit.taskstoissues

Convert tasks from `tasks.md` into GitHub Issues using the `gh` CLI.

## When to Use

After generating a `tasks.md` with `/speckit.tasks`, use this command to create GitHub Issues for each task. This bridges Speckit's task breakdown with GitHub's issue tracker.

## Prerequisites

- `tasks.md` must exist in the current feature folder
- `gh` CLI installed and authenticated (`gh auth status`)
- GitHub repository configured for the project

## Workflow

### Step 1: Locate tasks.md

Find the current feature's `tasks.md`:

```bash
# Default location (from /speckit.tasks output)
find .uatu/delivery -name "tasks.md" -newer .uatu/config/project.md | head -5
```

### Step 2: Parse Tasks

Read `tasks.md` and extract task items. Expected format (from `/speckit.tasks`):

```markdown
## Tasks

- [ ] Task 1: Description
  - Depends on: none
  - Acceptance: ...

- [ ] Task 2: Description
  - Depends on: Task 1
```

### Step 3: Create GitHub Issues

For each task, create a GitHub Issue:

```bash
gh issue create \
  --title "Task N: <task title>" \
  --body "<task description with acceptance criteria>" \
  --label "task" \
  --assignee "@me"
```

### Step 4: Link Issues

For tasks with dependencies, add dependency links in issue body:

```bash
# Reference dependent issue by number
gh issue edit <issue_number> --body "$(cat <<EOF
<original body>

**Depends on:** #<dependency_issue_number>
EOF
)"
```

## Implementation

When this command runs, execute the following:

1. Read the tasks.md file (ask user for path if ambiguous)
2. Parse each `- [ ]` task item with its description and metadata
3. Confirm with user: "Found N tasks. Create GitHub Issues? (y/N)"
4. For each task (in order):
   - Run `gh issue create` with task title and description
   - Capture the issue URL/number from output
   - Track dependency mappings
5. After all issues created, update dependent issues with cross-references
6. Output summary: list of created issues with URLs

## Output

```
Created GitHub Issues:
  #42 Task 1: Set up authentication middleware
  #43 Task 2: Implement JWT token validation (depends on #42)
  #44 Task 3: Add refresh token endpoint (depends on #42)
  ...

View all: gh issue list --label task
```

## Notes

- Issues are created in the current git repository's GitHub remote
- Use `--repo owner/repo` flag if working in a different repo
- Labels can be customized: edit this command to add project-specific labels
- For Jira instead of GitHub, use the Atlassian MCP tools (see WORKFLOW.md)
