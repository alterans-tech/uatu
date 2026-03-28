---
description: Security vulnerability scan with graded report (A-F). Covers secrets, input validation, auth, dependencies, and config.
---

# Security Scan

## Arguments

$ARGUMENTS

## Execution

Spawn the security-auditor agent to perform a comprehensive security scan across 5 categories.

```
Agent(subagent_type="security-auditor", prompt="Perform a comprehensive security scan of this project.

Scan the following 5 categories and produce a graded report.

## Category 1: SECRETS DETECTION

Search the entire codebase for exposed secrets:
- API keys: patterns like sk-, pk_, ghp_, AKIA, AIza
- Tokens: JWT secrets, OAuth tokens, bearer tokens in code
- Passwords: hardcoded passwords, database URLs with credentials
- Private keys: .pem content, RSA/EC key material in source

Also verify:
- .env files are in .gitignore
- No secrets in git history (check recent commits)
- Config files don't contain production credentials

## Category 2: INPUT VALIDATION

Check for injection vulnerabilities:
- SQL injection: raw queries without parameterization, string concatenation in queries
- XSS: unescaped user input rendered in HTML/templates, dangerouslySetInnerHTML without sanitization
- Command injection: user input passed to exec, spawn, system calls
- Path traversal: user input in file paths without sanitization
- NoSQL injection: unvalidated input in MongoDB queries

## Category 3: AUTHENTICATION & AUTHORIZATION

Check auth security:
- Protected routes missing auth middleware
- Session/token configuration (expiry, httpOnly, secure flags)
- CORS configuration (overly permissive origins)
- Rate limiting on auth endpoints (login, register, reset)
- Password hashing (bcrypt/argon2 vs md5/sha1)
- CSRF protection on state-changing endpoints

## Category 4: DEPENDENCY VULNERABILITIES

Check dependencies:
- Run the appropriate audit command for the project (npm audit, pip audit, go vet)
- Flag packages with known CVEs
- Flag severely outdated packages (2+ major versions behind)
- Check for packages with no maintenance (archived, no updates in 2+ years)

## Category 5: CONFIGURATION SECURITY

Check project and framework configuration:
- .claude/settings.json: overly permissive hook configurations
- .mcp.json: misconfigured MCP servers, exposed tokens
- File permissions: sensitive files readable by all
- .gitignore: coverage of .env, credentials, keys, secrets
- Debug mode: production code with debug flags enabled
- Error exposure: stack traces or internal details in API responses

---

## OUTPUT FORMAT

Produce a report in EXACTLY this format:

# Security Scan Report

**Date:** [current date]
**Grade:** [A/B/C/D/F]

## Summary

| Category | Findings | Highest Severity |
|----------|----------|-----------------|
| Secrets Detection | [count] | [Critical/High/Medium/Low/None] |
| Input Validation | [count] | [Critical/High/Medium/Low/None] |
| Auth & Authorization | [count] | [Critical/High/Medium/Low/None] |
| Dependencies | [count] | [Critical/High/Medium/Low/None] |
| Configuration | [count] | [Critical/High/Medium/Low/None] |

## Detailed Findings

### [Category Name]

| Severity | File | Line | Finding | Remediation |
|----------|------|------|---------|-------------|
| CRITICAL | path/file | 42 | [description] | [how to fix] |

*(Repeat for each category with findings)*

## Grading

- **A**: No findings of any severity
- **B**: Only Low severity findings
- **C**: Medium severity findings present
- **D**: High severity findings present
- **F**: Critical severity findings present

The grade is determined by the HIGHEST severity finding across all categories.")
```

Present the agent's report to the user without modification.
