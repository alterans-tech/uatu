#!/usr/bin/env python3
"""
python-example.py
Example hook written in Python showing language flexibility

Usage: Add to .claude/hooks.json:
{
  "event": "SessionStart",
  "scripts": [
    {"path": ".uatu/hooks/examples/python-example.py", "enabled": true}
  ]
}
"""

import json
import sys
import os
from pathlib import Path

def main():
    # Read hook input from stdin
    input_data = json.load(sys.stdin)

    event = input_data.get('event', '')
    working_dir = input_data.get('workingDirectory', '')

    # Example: Check if package.json exists (for Node.js projects)
    context = ""

    if working_dir:
        package_json = Path(working_dir) / "package.json"
        if package_json.exists():
            # Could parse and check versions, dependencies, etc.
            context = "Node.js project detected (package.json found)"

    # Output JSON response
    result = {
        "additionalContext": context,
        "error": None
    }

    print(json.dumps(result))

if __name__ == "__main__":
    main()
