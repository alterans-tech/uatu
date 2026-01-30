#!/bin/bash
# Smart worktree detection and guidance for Uatu projects
#
# Usage: .uatu/tools/worktree-helper.sh
#
# This script helps determine whether to use git worktrees or work directly
# in the master/main branch based on project maturity and git state.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${YELLOW}📁 Not in a git repository${NC}"
  echo "RECOMMENDATION: Initialize git first if this will be a versioned project"
  echo ""
  echo "To initialize:"
  echo "  git init"
  echo "  git add ."
  echo "  git commit -m 'Initial commit'"
  exit 0
fi

echo -e "${GREEN}✓ Git repository detected${NC}"
echo ""

# Check if this is a worktree
WORKTREE_COUNT=$(git worktree list 2>/dev/null | wc -l | tr -d ' ')
CURRENT_DIR=$(pwd)
IS_WORKTREE=false

if git worktree list 2>/dev/null | grep -q "$CURRENT_DIR"; then
  IS_WORKTREE=true
fi

echo "Repository Information:"
echo "  Total worktrees: $WORKTREE_COUNT"
echo "  Current directory is a worktree: $IS_WORKTREE"
echo ""

# Check for existing project indicators
HAS_PROJECT_CONFIG=false
if [ -f ".uatu/config/project.md" ]; then
  HAS_PROJECT_CONFIG=true
  echo -e "${GREEN}✓ Project configuration found (.uatu/config/project.md)${NC}"
else
  echo -e "${YELLOW}⚠ No project configuration found${NC}"
fi
echo ""

# Provide recommendations
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}RECOMMENDATIONS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$HAS_PROJECT_CONFIG" = true ]; then
  echo -e "${GREEN}✓ EXISTING PROJECT${NC}"
  echo ""
  echo "This appears to be an established project."
  echo ""
  echo "📋 Recommended workflow:"
  echo "  1. Create a worktree for each new feature"
  echo "  2. Keep master/main branch clean"
  echo "  3. Work in isolated worktree environments"
  echo ""
  echo "To create a worktree for a Jira task:"
  echo -e "${YELLOW}  git worktree add {project}-{NNN}-{type}-{JIRA-KEY}-{description} \\${NC}"
  echo -e "${YELLOW}    -b {JIRA-KEY}/{description}${NC}"
  echo ""
  echo "Example:"
  echo "  git worktree add platform-015-feat-RED-2700-user-dashboard \\"
  echo "    -b RED-2700/user-dashboard"
  echo ""

  if [ "$IS_WORKTREE" = false ] && [ "$WORKTREE_COUNT" -eq 1 ]; then
    echo -e "${YELLOW}⚠ You're currently in the main repository, not a worktree${NC}"
    echo "  Consider creating a worktree for your work to keep master clean."
  fi

  if [ "$IS_WORKTREE" = true ]; then
    CURRENT_BRANCH=$(git branch --show-current)
    echo -e "${GREEN}✓ You're in a worktree${NC}"
    echo "  Current branch: $CURRENT_BRANCH"
    echo "  You can work here safely without affecting other worktrees."
  fi
else
  echo -e "${YELLOW}⚠ NEW/SCRATCH PROJECT${NC}"
  echo ""
  echo "This appears to be a new project without configuration."
  echo ""
  echo "📋 Recommended workflow:"
  echo "  1. Work directly in master/main branch"
  echo "  2. Set up initial project structure"
  echo "  3. Create .uatu/config/project.md"
  echo "  4. Switch to worktree workflow once established"
  echo ""
  echo "After initial setup is complete, use worktrees for features."
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Export variables for programmatic use
if [ "$HAS_PROJECT_CONFIG" = true ]; then
  echo "EXISTING_PROJECT=true"
  echo "USE_WORKTREES=true"
else
  echo "NEW_PROJECT=true"
  echo "USE_WORKTREES=false"
fi

exit 0
