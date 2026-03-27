#!/bin/bash
# desktop-notification.sh
# Sends macOS desktop notification when a session ends.
# Profile: strict

set -euo pipefail

source "$(dirname "$0")/../hook-profile.sh"
check_profile "strict" || exit 0

# Only on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    exit 0
fi

osascript -e 'display notification "Claude Code session completed" with title "Uatu" sound name "Glass"' 2>/dev/null || true

exit 0
