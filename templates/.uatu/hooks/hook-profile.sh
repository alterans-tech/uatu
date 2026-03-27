#!/bin/bash
# hook-profile.sh
# Shared helper for hook tier/profile system.
# Source this at the top of any hook script:
#   source "$(dirname "$0")/../hook-profile.sh"
#   check_profile "standard" || exit 0
#
# Profiles (cumulative):
#   minimal  — only critical safety hooks (sensitive writes, config protection)
#   standard — minimal + workflow hooks (formatting, checkpoints, sequential thinking)
#   strict   — standard + quality gates (file-length warnings, event logging, notifications)

UATU_HOOK_PROFILE="${UATU_HOOK_PROFILE:-standard}"

check_profile() {
    local required_profile="$1"

    case "$required_profile" in
        minimal)
            # Always runs
            return 0
            ;;
        standard)
            [[ "$UATU_HOOK_PROFILE" == "standard" || "$UATU_HOOK_PROFILE" == "strict" ]]
            return $?
            ;;
        strict)
            [[ "$UATU_HOOK_PROFILE" == "strict" ]]
            return $?
            ;;
        *)
            return 0
            ;;
    esac
}
