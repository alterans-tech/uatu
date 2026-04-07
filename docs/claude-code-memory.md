# Claude Code Memory System

Reference guide for Claude Code's memory and context management.

---

## Memory Hierarchy

Claude Code uses a layered memory system. Files higher in the hierarchy load first and take precedence.

| Type | Location | Scope | Shared With |
|------|----------|-------|-------------|
| **Managed Policy** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | Organization-wide | All users |
| **Project Memory** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Project | Team (via git) |
| **Project Rules** | `./.claude/rules/*.md` | Project (modular) | Team (via git) |
| **User Memory** | `~/.claude/CLAUDE.md` | All projects | Just you |
| **Project Local** | `./CLAUDE.local.md` | Project (private) | Just you |

---

## File Locations

### Project Memory
```
project/
├── CLAUDE.md              # Main project instructions (git tracked)
├── CLAUDE.local.md        # Personal project prefs (auto-gitignored)
└── .claude/
    ├── CLAUDE.md          # Alternative location for main instructions
    └── rules/
        └── *.md           # Modular rule files
```

### User Memory
```
~/.claude/
├── CLAUDE.md              # Personal preferences (all projects)
└── rules/
    └── *.md               # Personal rule files
```

---

## Modular Rules (`.claude/rules/`)

Break large instruction sets into focused files:

```
.claude/rules/
├── code-style.md          # Formatting, conventions
├── testing.md             # Test patterns, coverage
├── api-design.md          # API standards
└── security.md            # Security requirements
```

### Path-Scoped Rules

Rules can apply only to specific files using YAML frontmatter:

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "src/services/**/*.ts"
---

# API Development Rules

- All endpoints must validate input
- Use standard error response format
```

### Glob Patterns

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All .ts files anywhere |
| `src/**/*` | Everything under src/ |
| `*.md` | Markdown in project root |
| `src/**/*.{ts,tsx}` | .ts and .tsx in src/ |
| `{src,lib}/**/*.ts` | .ts in src/ or lib/ |

---

## Imports

CLAUDE.md files can import other files:

```markdown
Project overview: @README.md
API docs: @docs/api.md
Personal prefs: @~/.claude/my-project.md
```

- Relative paths resolve from the importing file
- Supports `@~/` for home directory
- Max depth: 5 hops
- Imports inside code blocks are ignored

---

## Memory Loading Behavior

1. **Recursive discovery**: Claude reads CLAUDE.md files from cwd up to (not including) root
2. **Subtree discovery**: Nested CLAUDE.md files load when Claude reads files in those directories
3. **Auto-load**: All `.claude/rules/*.md` files load at startup
4. **Conditional load**: Path-scoped rules only activate for matching files

---

## Commands

| Command | Purpose |
|---------|---------|
| `/memory` | Open memory file in editor, view loaded files |
| `/init` | Bootstrap a CLAUDE.md for the project |

---

## Best Practices

### Content
- Be specific: "Use 2-space indentation" not "Format code properly"
- Use bullet points for individual instructions
- Group related items under markdown headings
- Review and update as project evolves

### Organization
- Keep rule files focused (one topic per file)
- Use descriptive filenames
- Use path-scoping sparingly (only when rules truly apply to specific files)
- Organize with subdirectories for large projects

### What to Include
- Frequently used commands (build, test, lint)
- Code style preferences and naming conventions
- Architectural patterns and decisions
- Project-specific workflows
- Common gotchas or constraints

### What NOT to Include
- Sensitive data (tokens, passwords, keys)
- Frequently changing information
- Duplicate information already in code comments
- Obvious conventions that Claude already knows

---

## Example Structure

```
project/
├── CLAUDE.md                    # Project overview, key commands
├── CLAUDE.local.md              # Your sandbox URLs, test credentials
└── .claude/
    ├── CLAUDE.md                # Detailed project instructions
    └── rules/
        ├── frontend/
        │   ├── react.md         # React patterns
        │   └── styles.md        # CSS conventions
        ├── backend/
        │   ├── api.md           # API design rules
        │   └── database.md      # DB conventions
        └── testing.md           # Test requirements
```

---

## Troubleshooting

### Rules not loading
- Check file is in `.claude/rules/` with `.md` extension
- Verify path patterns in frontmatter match your files
- Run `/memory` to see what's loaded

### Import not working
- Ensure path is correct (relative to importing file)
- Check it's not inside a code block
- Verify file exists and is readable

### Conflicts between rules
- Higher hierarchy wins (managed > project > user)
- Later-loaded rules can override earlier ones
- Be explicit to avoid ambiguity

---

*Reference: https://code.claude.com/docs/en/memory*
