#!/usr/bin/env bash
#
# Architecture Scanner for Uatu - The Watcher
# Scans a codebase and generates an architecture overview
#
# Usage: architecture-scanner.sh [project-dir] [output-file]
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get project directory (default to current)
PROJECT_DIR="${1:-.}"
OUTPUT_FILE="${2:-$PROJECT_DIR/.uatu/config/architecture.md}"

# Ensure project directory exists
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo -e "${RED}Error: Directory $PROJECT_DIR does not exist${NC}" >&2
    exit 1
fi

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo -e "${BLUE}Scanning project: $PROJECT_DIR${NC}"

# ============================================================================
# Helper Functions
# ============================================================================

detect_project_type() {
    local dir="$1"
    local types=()

    [[ -f "$dir/package.json" ]] && types+=("Node.js")
    [[ -f "$dir/pyproject.toml" ]] && types+=("Python")
    [[ -f "$dir/requirements.txt" ]] && types+=("Python")
    [[ -f "$dir/Cargo.toml" ]] && types+=("Rust")
    [[ -f "$dir/go.mod" ]] && types+=("Go")
    [[ -f "$dir/composer.json" ]] && types+=("PHP")
    [[ -f "$dir/pom.xml" ]] && types+=("Java/Maven")
    [[ -f "$dir/build.gradle" ]] && types+=("Java/Gradle")
    [[ -f "$dir/Gemfile" ]] && types+=("Ruby")
    [[ -f "$dir/mix.exs" ]] && types+=("Elixir")

    if [[ ${#types[@]} -eq 0 ]]; then
        echo "Unknown"
    else
        printf '%s, ' "${types[@]}" | sed 's/, $//'
    fi
}

detect_frameworks() {
    local dir="$1"
    local frameworks=()

    # Node.js frameworks
    if [[ -f "$dir/package.json" ]]; then
        grep -q '"react"' "$dir/package.json" 2>/dev/null && frameworks+=("React")
        grep -q '"vue"' "$dir/package.json" 2>/dev/null && frameworks+=("Vue")
        grep -q '"next"' "$dir/package.json" 2>/dev/null && frameworks+=("Next.js")
        grep -q '"express"' "$dir/package.json" 2>/dev/null && frameworks+=("Express")
        grep -q '"nestjs"' "$dir/package.json" 2>/dev/null && frameworks+=("NestJS")
        grep -q '"svelte"' "$dir/package.json" 2>/dev/null && frameworks+=("Svelte")
    fi

    # Python frameworks
    if [[ -f "$dir/pyproject.toml" ]] || [[ -f "$dir/requirements.txt" ]]; then
        grep -q "django" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && frameworks+=("Django")
        grep -q "flask" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && frameworks+=("Flask")
        grep -q "fastapi" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && frameworks+=("FastAPI")
    fi

    # Ruby frameworks
    [[ -f "$dir/Gemfile" ]] && grep -q "rails" "$dir/Gemfile" 2>/dev/null && frameworks+=("Ruby on Rails")

    if [[ ${#frameworks[@]} -eq 0 ]]; then
        echo "-"
    else
        printf '%s, ' "${frameworks[@]}" | sed 's/, $//'
    fi
}

detect_databases() {
    local dir="$1"
    local dbs=()

    # Check package.json
    if [[ -f "$dir/package.json" ]]; then
        grep -q '"pg"' "$dir/package.json" 2>/dev/null && dbs+=("PostgreSQL")
        grep -q '"mysql"' "$dir/package.json" 2>/dev/null && dbs+=("MySQL")
        grep -q '"mongodb"' "$dir/package.json" 2>/dev/null && dbs+=("MongoDB")
        grep -q '"redis"' "$dir/package.json" 2>/dev/null && dbs+=("Redis")
        grep -q '"sqlite3"' "$dir/package.json" 2>/dev/null && dbs+=("SQLite")
    fi

    # Check Python dependencies
    if [[ -f "$dir/pyproject.toml" ]] || [[ -f "$dir/requirements.txt" ]]; then
        grep -q "psycopg2\|asyncpg" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && dbs+=("PostgreSQL")
        grep -q "pymysql\|mysqlclient" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && dbs+=("MySQL")
        grep -q "pymongo" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && dbs+=("MongoDB")
        grep -q "redis" "$dir/pyproject.toml" "$dir/requirements.txt" 2>/dev/null && dbs+=("Redis")
    fi

    # Check for database files
    [[ -f "$dir/prisma/schema.prisma" ]] && dbs+=("Prisma")
    [[ -d "$dir/migrations" ]] && dbs+=("(migrations present)")

    if [[ ${#dbs[@]} -eq 0 ]]; then
        echo "-"
    else
        printf '%s, ' "${dbs[@]}" | sed 's/, $//'
    fi
}

find_entry_points() {
    local dir="$1"
    local -a entries=()

    # Common entry point files
    [[ -f "$dir/index.js" ]] && entries+=("index.js")
    [[ -f "$dir/index.ts" ]] && entries+=("index.ts")
    [[ -f "$dir/src/index.js" ]] && entries+=("src/index.js")
    [[ -f "$dir/src/index.ts" ]] && entries+=("src/index.ts")
    [[ -f "$dir/src/main.js" ]] && entries+=("src/main.js")
    [[ -f "$dir/src/main.ts" ]] && entries+=("src/main.ts")
    [[ -f "$dir/main.py" ]] && entries+=("main.py")
    [[ -f "$dir/src/main.py" ]] && entries+=("src/main.py")
    [[ -f "$dir/app.py" ]] && entries+=("app.py")
    [[ -f "$dir/server.js" ]] && entries+=("server.js")
    [[ -f "$dir/server.ts" ]] && entries+=("server.ts")

    # Check package.json main field (only if not already found)
    if [[ -f "$dir/package.json" ]]; then
        local main_file=$(python3 -c "import json; f=open('$dir/package.json'); d=json.load(f); print(d.get('main', ''))" 2>/dev/null || echo "")
        if [[ -n "$main_file" ]]; then
            local found=0
            for entry in "${entries[@]+"${entries[@]}"}"; do
                [[ "$entry" == "$main_file" ]] && found=1 && break
            done
            [[ $found -eq 0 ]] && entries+=("$main_file")
        fi
    fi

    if [[ ${#entries[@]} -eq 0 ]]; then
        echo "-"
    else
        local result=""
        for entry in "${entries[@]}"; do
            result="${result}${entry}, "
        done
        echo "${result%, }"
    fi
}

list_top_level_dirs() {
    local dir="$1"
    local dirs=()

    for item in "$dir"/*; do
        if [[ -d "$item" ]]; then
            local name=$(basename "$item")
            # Skip hidden dirs and common non-essential dirs
            if [[ "$name" != .* ]] && \
               [[ "$name" != "node_modules" ]] && \
               [[ "$name" != "vendor" ]] && \
               [[ "$name" != "dist" ]] && \
               [[ "$name" != "build" ]] && \
               [[ "$name" != "__pycache__" ]] && \
               [[ "$name" != "target" ]] && \
               [[ "$name" != "venv" ]] && \
               [[ "$name" != "env" ]]; then
                dirs+=("$name")
            fi
        fi
    done

    printf '%s\n' "${dirs[@]}"
}

detect_infrastructure() {
    local dir="$1"
    local infra=()

    [[ -f "$dir/Dockerfile" ]] && infra+=("Docker")
    [[ -f "$dir/docker-compose.yml" ]] || [[ -f "$dir/docker-compose.yaml" ]] && infra+=("Docker Compose")
    [[ -d "$dir/.github/workflows" ]] && infra+=("GitHub Actions")
    [[ -f "$dir/.gitlab-ci.yml" ]] && infra+=("GitLab CI")
    [[ -d "$dir/kubernetes" ]] || [[ -d "$dir/k8s" ]] && infra+=("Kubernetes")
    [[ -d "$dir/terraform" ]] && infra+=("Terraform")
    [[ -f "$dir/serverless.yml" ]] && infra+=("Serverless Framework")

    if [[ ${#infra[@]} -eq 0 ]]; then
        echo "-"
    else
        printf '%s, ' "${infra[@]}" | sed 's/, $//'
    fi
}

# ============================================================================
# Generate Architecture Document
# ============================================================================

echo -e "${BLUE}Generating architecture.md...${NC}"

# Get absolute path and then basename to avoid "." as project name
PROJECT_ABS=$(cd "$PROJECT_DIR" && pwd)
PROJECT_NAME=$(basename "$PROJECT_ABS")
CURRENT_DATE=$(date +%Y-%m-%d)
PROJECT_TYPE=$(detect_project_type "$PROJECT_DIR")
FRAMEWORKS=$(detect_frameworks "$PROJECT_DIR")
DATABASES=$(detect_databases "$PROJECT_DIR")
ENTRY_POINTS=$(find_entry_points "$PROJECT_DIR")
INFRASTRUCTURE=$(detect_infrastructure "$PROJECT_DIR")

# Start writing the document
cat > "$OUTPUT_FILE" << EOF
# Architecture Overview

> Auto-generated by Uatu - The Watcher
> Regenerate with: \`.uatu/tools/architecture-scanner.sh\` or \`uatu-install\`
> Generated: $CURRENT_DATE

---

## Project Summary

| Attribute | Value |
|-----------|-------|
| Name | $PROJECT_NAME |
| Type | $PROJECT_TYPE |
| Frameworks | $FRAMEWORKS |
| Databases | $DATABASES |
| Infrastructure | $INFRASTRUCTURE |

---

## Entry Points

| File | Purpose |
|------|---------|
EOF

# Add entry points
if [[ "$ENTRY_POINTS" == "-" ]]; then
    echo "| - | No standard entry points detected |" >> "$OUTPUT_FILE"
else
    IFS=', ' read -ra ENTRIES <<< "$ENTRY_POINTS"
    for entry in "${ENTRIES[@]}"; do
        echo "| \`$entry\` | Main entry point |" >> "$OUTPUT_FILE"
    done
fi

cat >> "$OUTPUT_FILE" << 'EOF'

---

## Directory Structure

```
EOF

# Add directory tree (top-level only for now)
echo "$PROJECT_NAME/" >> "$OUTPUT_FILE"
list_top_level_dirs "$PROJECT_DIR" | while read -r dirname; do
    echo "├── $dirname/" >> "$OUTPUT_FILE"
done

cat >> "$OUTPUT_FILE" << 'EOF'
```

---

## Key Directories

| Directory | Purpose |
|-----------|---------|
EOF

# Analyze key directories
for dirname in $(list_top_level_dirs "$PROJECT_DIR"); do
    case "$dirname" in
        src|lib|app)
            echo "| \`$dirname/\` | Source code |" >> "$OUTPUT_FILE"
            ;;
        test|tests|spec|__tests__)
            echo "| \`$dirname/\` | Test files |" >> "$OUTPUT_FILE"
            ;;
        docs|documentation)
            echo "| \`$dirname/\` | Documentation |" >> "$OUTPUT_FILE"
            ;;
        public|static|assets)
            echo "| \`$dirname/\` | Static assets |" >> "$OUTPUT_FILE"
            ;;
        config|configs)
            echo "| \`$dirname/\` | Configuration files |" >> "$OUTPUT_FILE"
            ;;
        scripts|bin)
            echo "| \`$dirname/\` | Scripts and utilities |" >> "$OUTPUT_FILE"
            ;;
        api|server)
            echo "| \`$dirname/\` | API/Server code |" >> "$OUTPUT_FILE"
            ;;
        client|frontend)
            echo "| \`$dirname/\` | Frontend code |" >> "$OUTPUT_FILE"
            ;;
        backend)
            echo "| \`$dirname/\` | Backend code |" >> "$OUTPUT_FILE"
            ;;
        database|db|migrations)
            echo "| \`$dirname/\` | Database related |" >> "$OUTPUT_FILE"
            ;;
        *)
            echo "| \`$dirname/\` | - |" >> "$OUTPUT_FILE"
            ;;
    esac
done

cat >> "$OUTPUT_FILE" << 'EOF'

---

## Technology Stack

### Frontend
EOF

# Detect frontend tech
if [[ -f "$PROJECT_DIR/package.json" ]]; then
    echo "" >> "$OUTPUT_FILE"
    if grep -q '"react"' "$PROJECT_DIR/package.json" 2>/dev/null; then
        echo "- **Framework:** React" >> "$OUTPUT_FILE"
        grep -q '"next"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **Meta-framework:** Next.js" >> "$OUTPUT_FILE"
    elif grep -q '"vue"' "$PROJECT_DIR/package.json" 2>/dev/null; then
        echo "- **Framework:** Vue.js" >> "$OUTPUT_FILE"
    elif grep -q '"svelte"' "$PROJECT_DIR/package.json" 2>/dev/null; then
        echo "- **Framework:** Svelte" >> "$OUTPUT_FILE"
    fi

    grep -q '"typescript"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **Language:** TypeScript" >> "$OUTPUT_FILE"
    grep -q '"tailwindcss"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **CSS:** Tailwind CSS" >> "$OUTPUT_FILE"
    grep -q '"sass"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **CSS:** Sass" >> "$OUTPUT_FILE"
else
    echo "- Not detected" >> "$OUTPUT_FILE"
fi

cat >> "$OUTPUT_FILE" << 'EOF'

### Backend
EOF

if [[ -f "$PROJECT_DIR/package.json" ]]; then
    echo "" >> "$OUTPUT_FILE"
    grep -q '"express"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **Framework:** Express.js" >> "$OUTPUT_FILE"
    grep -q '"nestjs"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **Framework:** NestJS" >> "$OUTPUT_FILE"
    grep -q '"fastify"' "$PROJECT_DIR/package.json" 2>/dev/null && echo "- **Framework:** Fastify" >> "$OUTPUT_FILE"
elif [[ -f "$PROJECT_DIR/pyproject.toml" ]] || [[ -f "$PROJECT_DIR/requirements.txt" ]]; then
    echo "" >> "$OUTPUT_FILE"
    grep -q "django" "$PROJECT_DIR/pyproject.toml" "$PROJECT_DIR/requirements.txt" 2>/dev/null && echo "- **Framework:** Django" >> "$OUTPUT_FILE"
    grep -q "flask" "$PROJECT_DIR/pyproject.toml" "$PROJECT_DIR/requirements.txt" 2>/dev/null && echo "- **Framework:** Flask" >> "$OUTPUT_FILE"
    grep -q "fastapi" "$PROJECT_DIR/pyproject.toml" "$PROJECT_DIR/requirements.txt" 2>/dev/null && echo "- **Framework:** FastAPI" >> "$OUTPUT_FILE"
elif [[ -f "$PROJECT_DIR/Gemfile" ]]; then
    echo "" >> "$OUTPUT_FILE"
    grep -q "rails" "$PROJECT_DIR/Gemfile" 2>/dev/null && echo "- **Framework:** Ruby on Rails" >> "$OUTPUT_FILE"
else
    echo "- Not detected" >> "$OUTPUT_FILE"
fi

cat >> "$OUTPUT_FILE" << 'EOF'

### Database
EOF

echo "" >> "$OUTPUT_FILE"
if [[ "$DATABASES" == "-" ]]; then
    echo "- Not detected" >> "$OUTPUT_FILE"
else
    echo "- $DATABASES" >> "$OUTPUT_FILE"
fi

cat >> "$OUTPUT_FILE" << 'EOF'

### Infrastructure
EOF

echo "" >> "$OUTPUT_FILE"
if [[ "$INFRASTRUCTURE" == "-" ]]; then
    echo "- Not detected" >> "$OUTPUT_FILE"
else
    echo "- $INFRASTRUCTURE" >> "$OUTPUT_FILE"
fi

cat >> "$OUTPUT_FILE" << 'EOF'

---

## Uatu Framework

| Component | Location |
|-----------|----------|
| Instructions | `CLAUDE.md` |
| Configuration | `.uatu/config/project.md` |
| Guides | `.uatu/guides/` |
| Agents | `.claude/agents/` |
| Commands | `.claude/commands/` |
| Constitution | `.uatu/config/constitution.md` |

---

## Notes

> This is an auto-generated overview. Update manually as needed or regenerate with the scanner.
>
> **To regenerate:**
> ```bash
> .uatu/tools/architecture-scanner.sh
> ```
EOF

echo -e "${GREEN}Architecture overview generated: $OUTPUT_FILE${NC}"
echo -e "${YELLOW}Review and update the Technology Stack section as needed${NC}"
