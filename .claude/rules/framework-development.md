# Uatu Framework Development Rules

Rules for developing the Uatu AI orchestration framework.

---

## Self-Improvement Protocol

When modifying Uatu itself:

1. **Test in clean environment** before committing
   ```bash
   mkdir /tmp/test-uatu && cd /tmp/test-uatu && uatu-install
   ```

2. **Update counts** if adding agents/skills/guides
3. **Update README.md** for user-facing changes
4. **Cross-reference guides** when adding documentation

---

## Component Locations

| Component | Path | Update Also |
|-----------|------|-------------|
| Agents | `templates/.claude/agents/` | CLAUDE.md counts |
| Skills | `templates/.claude/skills/` | CLAUDE.md counts |
| Guides | `templates/.uatu/guides/` | templates/CLAUDE.md |
| Hooks | `templates/.uatu/hooks/` | HOOKS.md guide |
| Tools | `templates/.uatu/tools/` | README.md |

---

## Naming Patterns

- Agents: `{category}/{name}.md` (e.g., `core/coder.md`)
- Skills: `{name}/SKILL.md` (e.g., `speckit.specify/SKILL.md`)
- Guides: `{UPPER-CASE}.md` (e.g., `WORKFLOW.md`)
- Hooks: `{trigger}/{name}.sh` (e.g., `session-start/load-project-context.sh`)

---

## Testing Changes

```bash
# Validate guides exist
for g in WORKFLOW SEQUENTIAL-THINKING TOOL-SELECTION; do
  [ -f "templates/.uatu/guides/${g}.md" ] && echo "✓ $g"
done

# Check for empty directories
find templates -type d -empty

# Run architecture scanner
./templates/.uatu/tools/architecture-scanner.sh
```
