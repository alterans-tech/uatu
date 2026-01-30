# Claude Code Skills

This directory contains enhanced slash commands in the SKILL.md format for Claude Code.

## What are Skills?

Skills are the next evolution of slash commands, providing:

- **Tool Restrictions**: Specify exactly which tools a skill can use
- **Hooks**: Pre and post-execution commands for validation and reporting
- **Enhanced Metadata**: Better descriptions and organization
- **Improved Error Handling**: Clear failure modes and recovery
- **Better Documentation**: Structured format for complex workflows

## Skills vs Commands

| Feature | Commands (.md) | Skills (SKILL.md) |
|---------|----------------|-------------------|
| Format | Markdown | Frontmatter + Markdown |
| Tool Control | All tools available | Restricted to allowed_tools |
| Hooks | No | Pre/post execution hooks |
| Validation | Manual | Automated via hooks |
| Handoffs | Yes | Yes (preserved) |
| Error Handling | Basic | Enhanced with hooks |

## Available Skills

### Speckit Skills

#### `/speckit.specify`
Create or update feature specifications from natural language.

**Location**: `speckit.specify/SKILL.md`

**Allowed Tools**: Read, Write, Edit, Glob, Grep, Bash

**What it does**:
- Generates feature folder structure
- Creates spec.md from natural language description
- Validates specification quality
- Creates requirements checklist
- Handles clarifications interactively

**Usage**:
```
/speckit.specify I want to add user authentication with OAuth2 support
```

**Output**:
- `.uatu/delivery/sprints/{sprint}/features/{NNN}-{JIRA-KEY}-{name}/spec.md`
- `.uatu/delivery/sprints/{sprint}/features/{NNN}-{JIRA-KEY}-{name}/checklists/requirements.md`

---

#### `/speckit.plan`
Execute implementation planning workflow to generate design artifacts.

**Location**: `speckit.plan/SKILL.md`

**Allowed Tools**: Read, Write, Edit, Glob, Grep, Bash, Task

**What it does**:
- Loads feature spec and constitution
- Generates research.md (resolves unknowns)
- Creates data-model.md (entities and relationships)
- Generates API contracts
- Updates agent context files

**Usage**:
```
/speckit.plan
```

**Prerequisites**: Requires existing spec.md

**Output**:
- `research.md` - Technology decisions and rationale
- `data-model.md` - Entity definitions
- `contracts/` - API schemas
- `quickstart.md` - Test scenarios
- Updated agent context

---

#### `/speckit.tasks`
Generate actionable, dependency-ordered task breakdown.

**Location**: `speckit.tasks/SKILL.md`

**Allowed Tools**: Read, Write, Edit, Glob, Grep, Bash

**What it does**:
- Loads all design artifacts
- Maps requirements to user stories
- Generates task list with dependencies
- Creates parallel execution opportunities
- Validates task completeness

**Usage**:
```
/speckit.tasks
```

**Prerequisites**: Requires spec.md and plan.md

**Output**:
- `tasks.md` - Checklist-formatted implementation tasks
- Dependency graph
- Parallel execution examples
- MVP scope recommendation

**Task Format**:
```
- [ ] T001 [P] [US1] Description with file path
```

---

### Git Skills

#### `/commit`
Smart git commit with conventional commit format and staging assistance.

**Location**: `commit/SKILL.md`

**Allowed Tools**: Read, Bash, Grep, Glob

**What it does**:
- Analyzes repository state
- Stages files intelligently
- Generates conventional commit messages
- Validates message format
- Prevents sensitive file commits
- Adds co-author attribution

**Usage Examples**:

**Auto-detect and generate message**:
```
/commit
```

**Explicit files and message**:
```
/commit src/auth.py src/models/user.py -m "feat(auth): add user authentication"
```

**All changes with custom message**:
```
/commit --all -m "refactor: simplify error handling"
```

**Interactive staging**:
```
/commit --interactive
```

**Safety Features**:
- Never commits .env, credentials, private keys
- Warns about large files (>1MB)
- Validates conventional commit format
- Prevents commits to main/master without warning
- Always adds co-author line

**Commit Format**:
```
<type>(<scope>): <subject>

<body>

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

**Types**: feat, fix, docs, style, refactor, perf, test, chore, ci, build

---

## SKILL.md Format

Each skill follows this structure:

```yaml
---
name: skill-name
description: Brief description of what the skill does
allowed_tools:
  - ToolName1
  - ToolName2
hooks:
  pre:
    - command: "command to run before execution"
      description: "What this hook does"
  post:
    - command: "command to run after execution"
      description: "What this hook does"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

[Detailed workflow instructions...]

## Guidelines

[Best practices and rules...]
```

## Creating New Skills

### 1. Create Directory Structure
```bash
mkdir -p templates/.claude/skills/{skill-name}
```

### 2. Create SKILL.md
Follow the frontmatter structure above with:
- Clear, action-oriented name
- Concise description
- Minimal tool allowlist
- Useful hooks for validation

### 3. Document Workflow
- Clear step-by-step outline
- Error handling instructions
- Output expectations
- Usage examples

### 4. Add Safety Rules
- Validation requirements
- Prohibited actions
- Warning conditions
- Recovery procedures

### 5. Test Thoroughly
- Test with various inputs
- Verify tool restrictions work
- Confirm hooks execute properly
- Validate error handling

## Migration from Commands

To convert an existing command to a skill:

1. **Create skill directory**: `mkdir templates/.claude/skills/{name}`
2. **Add frontmatter**:
   ```yaml
   ---
   name: command-name
   description: From command description field
   allowed_tools:
     - [List minimal tools needed]
   hooks:
     pre: [Validation commands]
     post: [Reporting commands]
   ---
   ```
3. **Copy command content**: Preserve User Input and Outline sections
4. **Add tool restrictions**: Review workflow, identify essential tools only
5. **Add hooks**: Pre-execution validation, post-execution reporting
6. **Test migration**: Verify functionality matches original command

## Hooks Best Practices

### Pre-hooks
Use for validation and prerequisites:
- Check file existence
- Verify environment state
- Validate configuration
- Confirm dependencies

**Examples**:
```yaml
pre:
  - command: "git status --porcelain"
    description: "Check for uncommitted changes"
  - command: "test -f .uatu/config/project.md"
    description: "Verify project configuration exists"
```

### Post-hooks
Use for reporting and cleanup:
- Show execution results
- Log completion
- Update state
- Notify user

**Examples**:
```yaml
post:
  - command: "git log -1 --oneline"
    description: "Show the commit just created"
  - command: "echo 'Task breakdown generated successfully'"
    description: "Confirm completion"
```

## Tool Restrictions

Skills should specify the **minimum** set of tools needed:

### Core Tools
- **Read**: Reading files
- **Write**: Creating new files
- **Edit**: Modifying existing files
- **Bash**: Running commands
- **Glob**: Finding files by pattern
- **Grep**: Searching file contents

### Specialized Tools
- **Task**: Spawning subagents
- **WebSearch**: Internet research
- **WebFetch**: Fetching web content

### Tool Selection Guidelines

| Task Type | Recommended Tools |
|-----------|------------------|
| File creation/modification | Read, Write, Edit |
| Code analysis | Read, Grep, Glob |
| Git operations | Bash, Read |
| Research/planning | Read, Write, Task |
| API integration | Bash, Read, Write |

## Error Handling

Skills should handle errors gracefully:

1. **Validation Errors**: Check prerequisites, fail early with clear messages
2. **Execution Errors**: Catch failures, provide recovery steps
3. **User Errors**: Detect invalid input, guide correction
4. **System Errors**: Handle missing tools/files, suggest fixes

## Skill Composition

Skills can invoke other skills via handoffs:

```yaml
handoffs:
  - label: Next Step
    agent: another-skill
    prompt: Description of what to do next
    send: true
```

**Example Flow**:
```
/speckit.specify → /speckit.plan → /speckit.tasks → /speckit.implement
```

## Skill Development Checklist

- [ ] Created skill directory
- [ ] Added SKILL.md with frontmatter
- [ ] Specified minimal allowed_tools
- [ ] Added validation pre-hooks
- [ ] Added reporting post-hooks
- [ ] Documented workflow clearly
- [ ] Included usage examples
- [ ] Added error handling
- [ ] Defined safety rules
- [ ] Tested with various inputs
- [ ] Updated this README

## Future Enhancements

Planned improvements for skills system:

- **Skill validation**: Automated testing framework
- **Skill discovery**: Better search and categorization
- **Skill composition**: Chain skills declaratively
- **Skill versioning**: Track changes and compatibility
- **Skill marketplace**: Share skills across projects
- **Skill analytics**: Usage tracking and optimization
- **Skill templates**: Boilerplate generators

---

*Part of the Uatu framework - AI orchestration for software development*
