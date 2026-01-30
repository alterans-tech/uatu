#!/bin/bash
# Uatu - The Watcher | Setup Script
# Run once to add uatu-install and uatu-setup to your PATH

set -e

UATU_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$UATU_DIR/bin"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo -e "${CYAN}    ██╗   ██╗ █████╗ ████████╗██╗   ██╗${NC}"
echo -e "${CYAN}    ██║   ██║██╔══██╗╚══██╔══╝██║   ██║${NC}"
echo -e "${CYAN}    ██║   ██║███████║   ██║   ██║   ██║${NC}"
echo -e "${CYAN}    ██║   ██║██╔══██║   ██║   ██║   ██║${NC}"
echo -e "${CYAN}    ╚██████╔╝██║  ██║   ██║   ╚██████╔╝${NC}"
echo -e "${CYAN}     ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ${NC}"
echo ""
echo "Uatu - The Watcher | PATH Setup"
echo "================================"
echo ""

# Detect shell
if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
    SHELL_NAME="zsh"
elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
    SHELL_NAME="bash"
else
    echo "Unknown shell. Please manually add $BIN_DIR to your PATH"
    exit 1
fi

# Check if already in PATH
if grep -q "uatu/bin" "$SHELL_RC" 2>/dev/null; then
    echo -e "${GREEN}Uatu is already in your PATH${NC}"
    echo "   Location: $BIN_DIR"
else
    echo "" >> "$SHELL_RC"
    echo "# Uatu - The Watcher AI Framework" >> "$SHELL_RC"
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
    echo -e "${GREEN}Added uatu/bin to $SHELL_RC${NC}"
fi

# Make scripts executable
chmod +x "$BIN_DIR/uatu-install"
chmod +x "$BIN_DIR/uatu-setup"

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: source $SHELL_RC"
echo "  2. Run: uatu-setup  (one-time MCP installation)"
echo "  3. Navigate to any project: cd /path/to/your-monorepo"
echo "  4. Run: uatu-install"
echo ""
