#!/bin/bash
# Uatu framework health check
# Verifies all dependencies and configurations

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}Uatu Framework Health Check${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ERRORS=0
WARNINGS=0

# Check if claude CLI exists
echo -e "${CYAN}Prerequisites:${NC}"
if command -v claude &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Claude CLI installed"
else
    echo -e "  ${RED}✗${NC} Claude CLI not found"
    ((ERRORS++))
fi

if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
    if [[ "$NODE_VERSION" -ge 18 ]]; then
        echo -e "  ${GREEN}✓${NC} Node.js $(node -v)"
    else
        echo -e "  ${YELLOW}⚠${NC} Node.js $(node -v) (recommend 18+)"
        ((WARNINGS++))
    fi
else
    echo -e "  ${RED}✗${NC} Node.js not found"
    ((ERRORS++))
fi
echo ""

# Check MCP servers
echo -e "${CYAN}MCP Servers (User-level):${NC}"
REQUIRED_USER_MCPS=("sequential-thinking" "claude-flow")
if command -v claude &> /dev/null; then
    MCP_LIST=$(claude mcp list 2>/dev/null || echo "")
    for mcp in "${REQUIRED_USER_MCPS[@]}"; do
        if echo "$MCP_LIST" | grep -q "$mcp"; then
            echo -e "  ${GREEN}✓${NC} $mcp"
        else
            echo -e "  ${RED}✗${NC} $mcp (missing - run uatu-setup)"
            ((ERRORS++))
        fi
    done
else
    echo -e "  ${YELLOW}⚠${NC} Cannot check - claude CLI missing"
fi
echo ""

# Check project files
echo -e "${CYAN}Project Configuration:${NC}"
REQUIRED_FILES=(
    ".uatu/UATU.md:Framework instructions"
    ".uatu/config/project.md:Project settings"
    ".uatu/config/architecture.md:Tech stack overview"
    ".claude/settings.json:Hooks configuration"
    ".mcp.json:MCP servers config"
    "CLAUDE.md:Project documentation"
)

for item in "${REQUIRED_FILES[@]}"; do
    file="${item%%:*}"
    desc="${item#*:}"
    if [[ -f "$file" ]]; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file ($desc)"
        ((ERRORS++))
    fi
done
echo ""

# Check .env tokens
echo -e "${CYAN}Environment:${NC}"
if [[ -f ".env" ]]; then
    echo -e "  ${GREEN}✓${NC} .env file exists"
    if grep -q "^GH_TOKEN=ghp_" ".env" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} GH_TOKEN configured"
    elif grep -q "^GH_TOKEN=" ".env" 2>/dev/null; then
        echo -e "  ${YELLOW}⚠${NC} GH_TOKEN present but may be placeholder"
        ((WARNINGS++))
    else
        echo -e "  ${YELLOW}⚠${NC} GH_TOKEN not set"
        ((WARNINGS++))
    fi
else
    echo -e "  ${YELLOW}⚠${NC} .env file missing"
    ((WARNINGS++))
fi
echo ""

# Check counts
echo -e "${CYAN}Component Counts:${NC}"
GUIDE_COUNT=$(find .uatu/guides -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
HOOK_COUNT=$(find .uatu/hooks -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
TOOL_COUNT=$(find .uatu/tools -name "*.sh" -o -name "*.py" 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(find .claude/commands -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

echo "  Guides: $GUIDE_COUNT"
echo "  Hooks: $HOOK_COUNT"
echo "  Tools: $TOOL_COUNT"
echo "  Skills: $SKILL_COUNT"

if [[ -d "$HOME/.claude/agents" ]]; then
    AGENT_COUNT=$(find "$HOME/.claude/agents" -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "  Agents (user): $AGENT_COUNT"
fi
echo ""

# Check version
echo -e "${CYAN}Version:${NC}"
if [[ -f ".uatu/.version" ]]; then
    VERSION=$(cat ".uatu/.version")
    echo "  Installed: $VERSION"
else
    echo -e "  ${YELLOW}⚠${NC} Version file missing"
    ((WARNINGS++))
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $ERRORS -gt 0 ]]; then
    echo -e "${RED}Health check failed: $ERRORS errors, $WARNINGS warnings${NC}"
    echo ""
    echo "Run 'uatu-setup' to install missing MCP servers"
    echo "Run 'uatu-install' to reinstall project files"
    exit 1
elif [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}Health check passed with $WARNINGS warnings${NC}"
    exit 0
else
    echo -e "${GREEN}Health check passed - all systems operational${NC}"
    exit 0
fi
