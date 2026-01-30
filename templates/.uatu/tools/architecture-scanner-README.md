# Architecture Scanner

Auto-generates `.uatu/config/architecture.md` by scanning the codebase.

## What It Detects

### Project Types
- Node.js (package.json)
- Python (pyproject.toml, requirements.txt)
- Rust (Cargo.toml)
- Go (go.mod)
- PHP (composer.json)
- Java (pom.xml, build.gradle)
- Ruby (Gemfile)
- Elixir (mix.exs)

### Frameworks
- **Frontend:** React, Vue, Svelte, Next.js
- **Backend:** Express, NestJS, Django, Flask, FastAPI, Rails
- **CSS:** Tailwind, Sass

### Databases
- PostgreSQL
- MySQL
- MongoDB
- Redis
- SQLite
- Prisma ORM

### Infrastructure
- Docker
- Docker Compose
- Kubernetes
- GitHub Actions
- GitLab CI
- Terraform
- Serverless Framework

### Code Structure
- Entry points (index.js/ts, main.py, server.js/ts, app.py)
- Directory structure
- Key directories (src/, tests/, docs/, etc.)

## Usage

### Auto-run (during install)
```bash
uatu-install
```

The scanner runs automatically and generates `architecture.md`.

### Manual run
```bash
.uatu/tools/architecture-scanner.sh
```

### Run on different directory
```bash
.uatu/tools/architecture-scanner.sh /path/to/project /path/to/output.md
```

## Output

Generates `.uatu/config/architecture.md` with:

1. **Project Summary** - Type, frameworks, databases, infrastructure
2. **Entry Points** - Main files that start the application
3. **Directory Structure** - Top-level folder tree
4. **Key Directories** - Purpose of each major folder
5. **Technology Stack** - Detailed breakdown by layer
6. **Uatu Framework** - Links to framework components

## Customization

The generated file can be edited manually. Sections to typically customize:

- Directory purposes (auto-detected but may need refinement)
- Technology stack details
- Additional architecture notes

To regenerate from scratch, just run the scanner again. It will overwrite the existing file.

## How It Works

1. **Scans for config files** - Looks for package.json, pyproject.toml, etc.
2. **Parses dependencies** - Extracts frameworks and libraries
3. **Finds entry points** - Detects main application files
4. **Analyzes structure** - Lists directories and categorizes them
5. **Generates markdown** - Creates formatted architecture.md

## Limitations

- Only detects explicitly declared dependencies
- May miss custom or proprietary frameworks
- Directory purposes are inferred from common patterns
- Does not analyze code complexity or architecture patterns

For custom frameworks or complex architectures, edit `architecture.md` manually after generation.

---

*Part of Uatu - The Watcher framework*
