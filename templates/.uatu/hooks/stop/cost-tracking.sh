#!/bin/bash
# cost-tracking.sh
# Log session boundaries to cost-log.md for manual cost review

set -euo pipefail

source "$(dirname "$0")/../hook-profile.sh"
check_profile "standard" || { echo '{"additionalContext": "", "error": null}'; exit 0; }

LOG_FILE=".uatu/delivery/cost-log.md"
TIMESTAMP_DATE=$(date +%Y-%m-%d)
TIMESTAMP_TIME=$(date +%H:%M)

if [[ ! -f "$LOG_FILE" ]]; then
    cat > "$LOG_FILE" << 'HEADER'
# Cost Tracking Log

> Note: Claude Code does not expose token counts to hooks.
> This log records session boundaries for manual cost review in the Claude console.

| Date | Time | Event |
|------|------|-------|
HEADER
fi

echo "| $TIMESTAMP_DATE | $TIMESTAMP_TIME | Session ended |" >> "$LOG_FILE"

echo "Cost log updated: $LOG_FILE" >&2
echo '{"additionalContext": "", "error": null}'
