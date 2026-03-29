---
description: Show time tracking for current project or across all projects. Supports filtering by project, week, and month.
---

# Time

## Arguments

$ARGUMENTS

## Execution

Parse flags from $ARGUMENTS:
- `--all` — show all projects combined
- `--week` — filter to current week
- `--month` — filter to current month
- `--project NAME` — filter to specific project
- No flags — show current project's sessions

### Data Source

Time data is stored at `~/.uatu/time-tracking/worklog.jsonl`. Each line is a JSON entry:
```json
{"project": "project-name", "start": "2026-03-28T10:00:00Z", "end": "2026-03-28T12:30:00Z", "duration_minutes": 150, "jira_key": "UAT"}
```

### Display Format

```
Time Report: [project name or "All Projects"]
Period: [week/month/all-time]

| Project | Sessions | Total Time | Avg Session |
|---------|----------|------------|-------------|
| uatu    | 12       | 18h 30m    | 1h 32m      |
| orion   | 8        | 12h 15m    | 1h 32m      |
| TOTAL   | 20       | 30h 45m    | 1h 32m      |
```

### If Worklog Doesn't Exist

If `~/.uatu/time-tracking/worklog.jsonl` doesn't exist, create it and inform the user:
"Time tracking file created at ~/.uatu/time-tracking/worklog.jsonl. Sessions will be auto-logged by Uatu hooks."

### Reading the Data

Use Python or bash to parse the JSONL:
```bash
python3 -c "
import json, sys
from datetime import datetime, timedelta
from pathlib import Path

worklog = Path.home() / '.uatu/time-tracking/worklog.jsonl'
if not worklog.exists():
    print('No time data found. Sessions are auto-logged by Uatu hooks.')
    sys.exit(0)

entries = [json.loads(line) for line in worklog.read_text().strip().split('\n') if line.strip()]
# Filter and aggregate based on flags...
"
```
