#!/usr/bin/env python3
"""
Claude Code Work Log - Analyze time spent on a project.

Usage:
    python worklog.py --project /path/to/project [--tz OFFSET] [--day YYYY-MM-DD]

Examples:
    python worklog.py --project /Users/me/myproject --tz -3
    python worklog.py --project /Users/me/myproject --day 2026-01-27
"""

import json, os, glob, argparse
from datetime import datetime, timedelta, timezone
from collections import defaultdict

TIMEOUT_MIN = 10

def get_project_dir(project_path):
    """Convert project path to Claude session folder path."""
    normalized = project_path.rstrip('/')
    folder_name = normalized.replace('/', '-')
    return os.path.expanduser(f"~/.claude/projects/{folder_name}/")

def parse_ts(ts, tz):
    """Parse timestamp (ISO string or Unix ms) to datetime."""
    if isinstance(ts, str):
        try:
            return datetime.fromisoformat(ts.replace('Z', '+00:00')).astimezone(tz)
        except:
            return None
    elif isinstance(ts, (int, float)):
        return datetime.fromtimestamp(ts / 1000, tz=timezone.utc).astimezone(tz)
    return None

def is_real_user_prompt(entry):
    """Check if entry is a real user prompt (not a tool result)."""
    if entry.get('type') != 'user':
        return False
    msg = entry.get('message', {})
    if isinstance(msg, dict):
        content = msg.get('content', '')
        if isinstance(content, list):
            for item in content:
                if isinstance(item, dict) and 'tool_use_id' in item:
                    return False
            return True
        elif isinstance(content, dict) and 'tool_use_id' in content:
            return False
    return True

def analyze_project(project_path, tz_offset, filter_day=None):
    """Analyze work time for a project."""
    project_dir = get_project_dir(project_path)
    target_tz = timezone(timedelta(hours=tz_offset))

    if not os.path.exists(project_dir):
        print(f"Error: Session folder not found: {project_dir}")
        print(f"Expected path: {project_dir}")
        print(f"\nAvailable projects:")
        claude_dir = os.path.expanduser("~/.claude/projects/")
        if os.path.exists(claude_dir):
            for d in sorted(os.listdir(claude_dir)):
                print(f"  {d}")
        return

    files = glob.glob(project_dir + "*.jsonl")
    if not files:
        print(f"Error: No session files found in {project_dir}")
        return

    # Collect all events by day
    all_events_by_day = defaultdict(list)
    real_prompts_by_day = defaultdict(list)

    for f in files:
        with open(f, 'r') as fh:
            for line in fh:
                try:
                    e = json.loads(line.strip())
                    ts = e.get('timestamp') or e.get('ts')
                    msg_type = e.get('type')
                    if ts and msg_type in ('user', 'assistant'):
                        p = parse_ts(ts, target_tz)
                        if p:
                            day = p.strftime('%Y-%m-%d')
                            if filter_day and day != filter_day:
                                continue
                            all_events_by_day[day].append((p, msg_type))
                            if is_real_user_prompt(e):
                                real_prompts_by_day[day].append(p)
                except:
                    continue

    grand_total_work = 0
    grand_total_prompts = 0

    for day in sorted(all_events_by_day.keys()):
        all_events = sorted(all_events_by_day[day], key=lambda x: x[0])
        real_user_prompts = sorted(real_prompts_by_day[day])

        if len(all_events) < 2:
            continue

        # Build blocks
        blocks = []
        block_start = all_events[0][0]
        block_end = all_events[0][0]

        for i in range(1, len(all_events)):
            ts, msg_type = all_events[i]
            prev_ts = all_events[i-1][0]
            gap_min = (ts - prev_ts).total_seconds() / 60

            if gap_min > TIMEOUT_MIN:
                blocks.append({'start': block_start, 'end': block_end})
                block_start = ts
                block_end = ts
            else:
                block_end = ts

        blocks.append({'start': block_start, 'end': block_end})

        # Calculate block data
        block_data = []
        max_dur = 0

        for b in blocks:
            events_in_block = [(ts, t) for ts, t in all_events if b['start'] <= ts <= b['end']]
            events_in_block.sort()

            if len(events_in_block) > 1:
                gaps = [(events_in_block[i][0] - events_in_block[i-1][0]).total_seconds() / 60
                        for i in range(1, len(events_in_block))]
                work = sum(g for g in gaps if g <= TIMEOUT_MIN)
            else:
                work = 0

            user_prompts = [u for u in real_user_prompts if b['start'] <= u <= b['end']]

            if len(user_prompts) > 1:
                user_gaps = [(user_prompts[i] - user_prompts[i-1]).total_seconds()
                             for i in range(1, len(user_prompts))]
                avg_gap = sum(user_gaps) / len(user_gaps)
            else:
                avg_gap = 0

            if work >= 1:  # At least 1 minute
                block_data.append({
                    'start': b['start'],
                    'end': b['end'],
                    'work': work,
                    'prompts': len(user_prompts),
                    'avg_gap': avg_gap
                })
                if work > max_dur:
                    max_dur = work

        if not block_data:
            continue

        date_obj = datetime.strptime(day, '%Y-%m-%d')
        day_name = date_obj.strftime('%A, %b %d')

        print(f"\n{day_name}")
        print()
        print("#   Started   Stopped   Duration                          Prompts   Avg Gap")

        total_work = 0
        total_prompts = 0

        for i, b in enumerate(block_data, 1):
            start = b['start'].strftime('%H:%M')
            end = b['end'].strftime('%H:%M')
            work = b['work']
            prompts = b['prompts']
            avg_gap = b['avg_gap']

            total_work += work
            total_prompts += prompts

            dur_str = f"{work:.0f} min"

            bar_len = int((work / max_dur) * 30) if max_dur > 0 else 0
            bar = "█" * bar_len

            if avg_gap >= 60:
                gap_str = f"{avg_gap/60:.1f}m"
            else:
                gap_str = f"{avg_gap:.0f}s" if avg_gap > 0 else "-"

            print(f"{i:<3} {start:<9} {end:<9} {dur_str:<8} {bar:<30} {prompts:<9} {gap_str}")

        first = block_data[0]['start'].strftime('%H:%M')
        last = block_data[-1]['end'].strftime('%H:%M')

        print()
        print(f"Day total: {total_work:.0f} min ({total_work/60:.1f}h) | Window: {first} → {last} | Prompts: {total_prompts}")

        grand_total_work += total_work
        grand_total_prompts += total_prompts

    print("\n" + "="*70)
    print(f"GRAND TOTAL: {grand_total_work:.0f} min ({grand_total_work/60:.1f}h) | Prompts: {grand_total_prompts}")
    print("="*70)

def main():
    parser = argparse.ArgumentParser(description="Analyze Claude Code work time")
    parser.add_argument("--project", type=str, required=True, help="Project path")
    parser.add_argument("--tz", type=float, default=0, help="Timezone offset (e.g., -3 for GMT-3)")
    parser.add_argument("--day", type=str, default=None, help="Filter to specific day (YYYY-MM-DD)")
    args = parser.parse_args()

    analyze_project(args.project, args.tz, args.day)

if __name__ == "__main__":
    main()
