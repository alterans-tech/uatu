#!/usr/bin/env python3
"""
Prompt Engineering Quality Analyzer
Analyzes Claude Code history.jsonl for prompt quality metrics.
"""

import json
import sys
from datetime import datetime, timezone
from collections import defaultdict
from pathlib import Path
import re
import statistics

HISTORY_FILE = Path.home() / ".claude" / "history.jsonl"

def load_prompts(path):
    prompts = []
    with open(path) as f:
        for line in f:
            try:
                obj = json.loads(line.strip())
                display = obj.get("display", "")
                ts = obj.get("timestamp", 0)
                project = obj.get("project", "unknown")
                session_id = obj.get("sessionId", "")

                if not display or not ts:
                    continue

                dt = datetime.fromtimestamp(ts / 1000, tz=timezone.utc)
                month = dt.strftime("%Y-%m")

                # Extract workspace and project name from path
                project_path = project.replace("/Users/arnaldosilva/Workspace/projects/", "")
                parts = project_path.split("/")
                workspace = parts[0] if parts else "unknown"
                project_name = "/".join(parts[:2]) if len(parts) > 1 else workspace

                prompts.append({
                    "text": display,
                    "timestamp": dt,
                    "month": month,
                    "workspace": workspace,
                    "project": project_name,
                    "project_full": project_path,
                    "session_id": session_id,
                    "length": len(display),
                    "word_count": len(display.split()),
                })
            except (json.JSONDecodeError, ValueError):
                continue
    return prompts


# --- Dimension definitions ---
# 5 research-backed dimensions with no signal overlap.
# Each signal belongs to exactly ONE dimension.
# Base score = 1 (not 3-5) for wider dynamic range.
#
# Anchors:
#   2 = clearly bad    ("fix it", "make it better")
#   5 = adequate       ("fix the login bug in auth.ts")
#   8 = excellent      (file + function + behavior + constraints + done-condition)
#
# Research basis:
#   - PEEM (arXiv 2603.10477): clarity/structure axis
#   - arXiv 2601.13118: I/O format, post-conditions, examples top predictors
#   - arXiv 2508.03678: specificity is #1 variable for pass@1
#   - Cursor best practices: file refs, verifiable goals, methodology declarations

DIMENSIONS = ["intent", "context", "specificity", "scope", "verifiability"]

DIMENSION_WEIGHTS = {
    "intent": 0.20,
    "context": 0.25,
    "specificity": 0.20,
    "scope": 0.15,
    "verifiability": 0.20,
}


def score_prompt(text):
    """Score a single prompt on 5 research-backed dimensions. Returns dict of scores.

    Each signal is counted in exactly one dimension (no double-counting).
    Base score = 1 for all dimensions, giving a dynamic range of 1.0-9.0+.
    """
    scores = {}
    t = text.lower().strip()
    words = t.split()
    wc = len(words)

    # --- 1. Intent (0.20) ---
    # Does the prompt state what to do? Action verb + identifiable target.
    # Signals: action verbs, word count (very short = unclear intent)
    action_verbs = [
        "fix", "add", "create", "implement", "write", "build", "update",
        "refactor", "remove", "delete", "move", "rename", "test", "review",
        "deploy", "configure", "set up", "generate", "analyze", "research",
        "design", "optimize", "migrate", "convert", "extract", "merge",
        "replace", "integrate", "debug", "upgrade", "downgrade", "install",
    ]
    has_verb = any(v in t for v in action_verbs)
    # Check for a noun/target after the verb (component, module, feature name)
    has_target = bool(re.search(
        r'(?:the|a|an|this|that|our|my)\s+\w+', t
    )) or bool(re.search(r'[A-Z][a-z]+[A-Z]', text))  # camelCase identifier
    # Also match verb + noun patterns without articles: "add tests", "fix bug", "create endpoint"
    if not has_target:
        has_target = bool(re.search(
            r'(?:fix|add|create|implement|write|build|update|refactor|remove|delete'
            r'|test|review|deploy|generate|analyze|design|optimize|extract|merge'
            r'|replace|integrate|debug|upgrade|install)\s+\w{3,}', t
        ))

    intent = 1
    if has_verb:
        intent += 3
    if has_target:
        intent += 2
    if wc >= 6:
        intent += 1
    if wc >= 15:
        intent += 1
    if wc >= 30:
        intent += 1
    if wc <= 2:
        intent -= 1  # can go to 0, clamped below
    scores["intent"] = max(min(intent, 10), 1)

    # --- 2. Context (0.25) ---
    # Does the prompt provide grounding material?
    # Signals: file paths/extensions, code blocks, backtick refs, error msgs, URLs,
    #          component/module names, function refs
    has_file_ext = bool(re.search(
        r'\.(ts|js|py|go|rs|sh|md|json|yaml|yml|sql|tsx|jsx|css|html|java|kt|rb|php|c|cpp|h)\b', t
    ))
    has_path = "/" in text and not text.startswith("http") and not text.startswith("/")
    has_code_block = "```" in text
    has_backtick_ref = "`" in text and not has_code_block
    has_error_msg = bool(re.search(r'error|exception|traceback|stack\s*trace|fail(ed|ure|ing)', t))
    has_url = bool(re.search(r'https?://', t))
    has_function_ref = bool(re.search(r'[a-z]+[A-Z][a-z]+\(', text)) or bool(re.search(r'\w+\(\)', text))
    # Component/module names — PascalCase or kebab-case identifiers
    has_component_name = bool(re.search(r'\b[A-Z][a-z]+(?:[A-Z][a-z]+)+\b', text))
    has_named_thing = bool(re.search(r'\b(?:the|a|this)\s+\w{3,}\s+(?:file|module|component|service|function|class|endpoint|route|page|hook|test|script|table|model|schema|config)', t))

    context = 2  # base 2: most prompts name at least something implicitly
    if has_file_ext:
        context += 2
    if has_path:
        context += 1
    if has_code_block:
        context += 3
    if has_backtick_ref:
        context += 2
    if has_error_msg:
        context += 1
    if has_url:
        context += 1
    if has_function_ref:
        context += 1
    if has_component_name:
        context += 1
    if has_named_thing:
        context += 1
    scores["context"] = max(min(context, 10), 1)

    # --- 3. Specificity (0.20) ---
    # Does the prompt define precise behavior, not vague outcomes?
    # Signals: assertive language, absence of vague words, concrete values/names
    vague_words = {
        "some", "maybe", "probably", "something", "stuff", "things",
        "better", "improve", "good", "nice", "properly", "appropriate",
        "correct", "right", "issue", "problem",
    }
    assertive_words = {
        "exactly", "must", "never", "always", "require", "ensure",
        "return", "accept", "reject", "throw", "emit", "render",
        "instead", "rather", "specifically", "only",
    }
    vague_count = sum(1 for w in words if w in vague_words)
    assertive_count = sum(1 for w in words if w in assertive_words)
    # Concrete values: numbers, quoted strings, named constants
    has_concrete_values = bool(re.search(r'\b\d+\b', text)) or bool(re.search(r'["\'][^"\']+["\']', text))
    has_named_behavior = bool(re.search(r'(?:should|must|will)\s+\w+', t))

    specificity = 2  # base 2: most prompts have some implicit specificity
    specificity += min(assertive_count * 2, 4)
    specificity -= min(vague_count, 2)
    if has_concrete_values:
        specificity += 2
    if has_named_behavior:
        specificity += 2
    if wc >= 10:
        specificity += 1
    if wc >= 25:
        specificity += 1  # longer prompts tend to carry more detail
    scores["specificity"] = max(min(specificity, 10), 1)

    # --- 4. Scope (0.15) ---
    # Does the prompt define boundaries and decompose multi-concern tasks?
    # Signals: constraints (don't/only/without), decomposition (bullets/numbers/headers)
    has_constraint = bool(re.search(r"\bdon'?t\b|\bdo not\b|\bnever\b|\bmust not\b|\bavoid\b|\bwithout\b|\bonly\b", t))
    has_numbers = bool(re.search(r'^\d+[\.\)]', text, re.MULTILINE))
    has_bullets = bool(re.search(r'^[\s]*[-*]', text, re.MULTILINE))
    has_headers = bool(re.search(r'^#{1,4}\s', text, re.MULTILINE))
    has_newlines = "\n" in text
    line_count = text.count("\n") + 1
    # Multi-concern without decomposition is a scope problem
    multi_concern_words = sum(1 for w in ["and", "also", "plus", "additionally", "as well"] if w in words)
    is_multi_concern = multi_concern_words >= 2 or (wc > 30 and not has_newlines)

    # Short, single-concern prompts: scope isn't really relevant, so start neutral.
    # But constraints should still push above neutral.
    if wc <= 15 and not is_multi_concern:
        scope = 5  # neutral baseline for simple prompts
        if has_constraint:
            scope += 3  # constraints always valuable
    else:
        # Multi-concern or long prompts: decomposition matters
        scope = 1
        if has_constraint:
            scope += 3
        if has_numbers:
            scope += 2
        if has_bullets:
            scope += 2
        if has_headers:
            scope += 1
        if has_newlines and line_count > 3:
            scope += 1
        if is_multi_concern and not (has_numbers or has_bullets or has_headers):
            scope -= 2  # penalty: multiple concerns, no decomposition
    scores["scope"] = max(min(scope, 10), 1)

    # --- 5. Verifiability (0.20) ---
    # Can someone confirm the task is done?
    # Signals: expected output, done-conditions, verification commands, format requests
    has_expected = bool(re.search(
        r'expect|should\s+return|should\s+produce|should\s+output|should\s+show'
        r'|done\s+when|must\s+pass|result\s+should|output\s+should', t
    ))
    has_verification_cmd = bool(re.search(
        r'run\s+\w|npm\s+test|pytest|go\s+test|make\s+test|verify|confirm\s+(?:that|it|before)', t
    ))
    has_format_request = bool(re.search(
        r'\btable\b|\bjson\b|\bmarkdown\b|\bformat\b|structure\s+as|present\s+as|\bcsv\b', t
    ))
    has_example_io = bool(re.search(r'(?:input|output|example|e\.g\.|for\s+instance)\s*:', t))
    has_test_expectation = bool(re.search(r'test|spec|assert|expect\(|should\s+(?:be|have|equal|match)', t))

    verifiability = 2  # base 2: many coding tasks have implicitly verifiable outcomes
    if has_expected:
        verifiability += 3
    if has_verification_cmd:
        verifiability += 2
    if has_format_request:
        verifiability += 2
    if has_example_io:
        verifiability += 2
    if has_test_expectation:
        verifiability += 1
    scores["verifiability"] = max(min(verifiability, 10), 1)

    # --- Composite ---
    scores["composite"] = sum(scores[k] * DIMENSION_WEIGHTS[k] for k in DIMENSION_WEIGHTS)

    return scores


def classify_prompt_type(text):
    """Classify the prompt into a category."""
    t = text.lower().strip()
    wc = len(t.split())

    # --- Exempt categories (not scored) ---

    # Execution confirmations: short prompts that greenlight a planned action.
    # These are GOOD delegation — the work was front-loaded into planning.
    execution_phrases = [
        "yes", "yeah", "yep", "y", "ok", "okay", "sure", "go", "go ahead",
        "do it", "run it", "ship it", "looks good", "lgtm", "proceed", "continue",
        "approved", "confirm", "confirmed", "let's go", "send it", "merge it",
        "push it", "deploy it", "commit it", "that's correct", "correct",
        "that works", "perfect", "exactly", "agreed", "go for it", "make it so",
        "sounds good", "sounds right", "right", "yup", "please do", "execute",
    ]
    if t in execution_phrases or (wc <= 4 and any(t.startswith(p) for p in execution_phrases)):
        return "execution"

    # Slash commands and shell commands — user is using tools, not writing prose
    if any(t.startswith(p) for p in ["/", "!"]):
        return "command"

    # Acknowledgments — social/conversational, not instructional
    ack_phrases = [
        "thanks", "thank you", "got it", "understood", "i see", "noted",
        "cool", "great", "awesome", "nice", "good to know", "makes sense",
    ]
    if t in ack_phrases or (wc <= 4 and any(t == p or t.startswith(p) for p in ack_phrases)):
        return "acknowledgment"

    # Contextual follow-ups: short questions or replies where conversation context
    # provides all the structure/files/criteria. Penalizing these is wrong.
    if wc <= 8 and "?" in text:
        return "followup"

    # Continuations — referring to prior context ("now do the same for...", "also for the other files")
    continuation_patterns = [
        r"^(?:now\s+)?(?:do\s+)?(?:the\s+)?same\s+(?:for|thing|with)",
        r"^(?:and\s+)?(?:now\s+)?(?:the\s+)?(?:other|rest|remaining)",
        r"^also\s+(?:for|do|add|update)",
        r"^next\b",
    ]
    if wc <= 12 and any(re.search(p, t) for p in continuation_patterns):
        return "continuation"

    # Corrections — refining a previous instruction ("no, I meant...", "not that, the...")
    correction_patterns = [
        r"^no[,.]?\s+(?:i\s+meant|not\s+that|the\s+other|actually|wait)",
        r"^(?:i\s+meant|actually|wait|sorry)",
        r"^not\s+(?:that|the|this)",
    ]
    if wc <= 12 and any(re.search(p, t) for p in correction_patterns):
        return "correction"

    # Ultra-terse that are NOT execution confirmations — these are legitimately low quality
    if wc <= 2:
        return "ultra-terse"
    if wc <= 5:
        return "terse"

    # --- Scored categories ---

    if "?" in text:
        return "question"
    if any(w in t for w in ["fix", "bug", "error", "broken", "issue"]):
        return "bug-fix"
    if any(w in t for w in ["add", "create", "implement", "build", "new"]):
        return "feature"
    if any(w in t for w in ["refactor", "clean", "restructure", "rename"]):
        return "refactor"
    if any(w in t for w in ["review", "check", "analyze", "look at"]):
        return "review"
    if any(w in t for w in ["test", "spec", "coverage"]):
        return "testing"
    if any(w in t for w in ["deploy", "push", "merge", "commit"]):
        return "deploy"
    if any(w in t for w in ["research", "find", "search", "explore"]):
        return "research"
    if any(w in t for w in ["explain", "how", "what", "why"]):
        return "question"
    return "general"


# Categories exempt from quality scoring — they are valid prompt types
# where structure/context/criteria would be noise, not signal.
EXEMPT_TYPES = {"execution", "command", "followup", "acknowledgment", "continuation", "correction"}


def analyze(prompts):
    """Run full analysis on all prompts."""
    results = {
        "total": len(prompts),
        "date_range": {
            "start": min(p["timestamp"] for p in prompts).isoformat(),
            "end": max(p["timestamp"] for p in prompts).isoformat(),
        },
        "by_month": defaultdict(lambda: {"count": 0, "scores": [], "types": defaultdict(int)}),
        "by_project": defaultdict(lambda: {"count": 0, "scores": [], "types": defaultdict(int), "months": defaultdict(lambda: {"count": 0, "scores": []})}),
        "by_workspace": defaultdict(lambda: {"count": 0, "scores": []}),
        "overall_scores": [],
        "overall_types": defaultdict(int),
        "length_stats": {},
        "top_prompts": [],
        "worst_prompts": [],
        "ultra_terse_count": 0,
        "dimension_averages": defaultdict(list),
    }

    for p in prompts:
        text = p["text"]
        scores = score_prompt(text)
        ptype = classify_prompt_type(text)
        month = p["month"]
        project = p["project"]
        workspace = p["workspace"]
        is_exempt = ptype in EXEMPT_TYPES

        # Always count type distribution (all prompts)
        results["overall_types"][ptype] += 1
        if len(text.split()) <= 2:
            results["ultra_terse_count"] += 1

        # Only include non-exempt prompts in quality scores
        if not is_exempt:
            results["overall_scores"].append(scores["composite"])

            for dim in DIMENSIONS:
                results["dimension_averages"][dim].append(scores[dim])

            # By month (scored only)
            results["by_month"][month]["scores"].append(scores["composite"])

            # By project (scored only)
            results["by_project"][project]["scores"].append(scores["composite"])
            results["by_project"][project]["months"][month]["scores"].append(scores["composite"])

            # By workspace (scored only)
            results["by_workspace"][workspace]["scores"].append(scores["composite"])

            # Track top/worst (scored only)
            entry = {"text": text[:200], "score": scores["composite"], "month": month, "project": project, "scores": scores}
            results["top_prompts"].append(entry)
            results["worst_prompts"].append(entry)

        # Always count totals
        results["by_month"][month]["count"] += 1
        results["by_month"][month]["types"][ptype] += 1
        results["by_project"][project]["count"] += 1
        results["by_project"][project]["types"][ptype] += 1
        results["by_project"][project]["months"][month]["count"] += 1
        results["by_workspace"][workspace]["count"] += 1

    # Sort and trim top/worst
    results["top_prompts"].sort(key=lambda x: x["score"], reverse=True)
    results["top_prompts"] = results["top_prompts"][:20]
    results["worst_prompts"].sort(key=lambda x: x["score"])
    results["worst_prompts"] = results["worst_prompts"][:20]

    # Length stats
    lengths = [p["length"] for p in prompts]
    word_counts = [p["word_count"] for p in prompts]
    results["length_stats"] = {
        "char_mean": statistics.mean(lengths),
        "char_median": statistics.median(lengths),
        "char_stdev": statistics.stdev(lengths) if len(lengths) > 1 else 0,
        "word_mean": statistics.mean(word_counts),
        "word_median": statistics.median(word_counts),
        "word_stdev": statistics.stdev(word_counts) if len(word_counts) > 1 else 0,
    }

    return results


def print_report(results):
    """Print formatted analysis report."""
    print("=" * 80)
    print("PROMPT ENGINEERING QUALITY ANALYSIS")
    print("=" * 80)
    total = results["total"]
    scored = len(results["overall_scores"])
    exempt = total - scored
    exempt_types = {t: c for t, c in results["overall_types"].items() if t in EXEMPT_TYPES}
    print(f"\nTotal prompts: {total}")
    print(f"  Scored:  {scored} (quality-assessed)")
    print(f"  Exempt:  {exempt} (valid but not scored — {', '.join(f'{t}: {c}' for t, c in sorted(exempt_types.items(), key=lambda x: -x[1]))})")
    print(f"Date range: {results['date_range']['start'][:10]} to {results['date_range']['end'][:10]}")
    print(f"Ultra-terse prompts (<=2 words, non-exempt): {results['ultra_terse_count']} ({results['ultra_terse_count']/total*100:.1f}%)")

    # Overall composite
    all_scores = results["overall_scores"]
    print(f"\n{'='*80}")
    print("OVERALL COMPOSITE SCORE")
    print(f"{'='*80}")
    print(f"Mean:   {statistics.mean(all_scores):.2f} / 10")
    print(f"Median: {statistics.median(all_scores):.2f} / 10")
    print(f"Stdev:  {statistics.stdev(all_scores):.2f}")
    print(f"Min:    {min(all_scores):.2f}")
    print(f"Max:    {max(all_scores):.2f}")

    # Dimension averages
    print(f"\n{'='*80}")
    print("DIMENSION AVERAGES (1-10 scale)")
    print(f"{'='*80}")
    for dim in DIMENSIONS:
        vals = results["dimension_averages"][dim]
        weight = DIMENSION_WEIGHTS[dim]
        print(f"  {dim:20s}: {statistics.mean(vals):5.2f}  (median: {statistics.median(vals):.2f}, stdev: {statistics.stdev(vals):.2f}, weight: {weight:.0%})")

    # Prompt types
    print(f"\n{'='*80}")
    print("PROMPT TYPE DISTRIBUTION")
    print(f"{'='*80}")
    total = results["total"]
    for ptype, count in sorted(results["overall_types"].items(), key=lambda x: -x[1]):
        print(f"  {ptype:15s}: {count:5d} ({count/total*100:5.1f}%)")

    # Length stats
    ls = results["length_stats"]
    print(f"\n{'='*80}")
    print("PROMPT LENGTH STATISTICS")
    print(f"{'='*80}")
    print(f"  Characters: mean={ls['char_mean']:.0f}, median={ls['char_median']:.0f}, stdev={ls['char_stdev']:.0f}")
    print(f"  Words:      mean={ls['word_mean']:.0f}, median={ls['word_median']:.0f}, stdev={ls['word_stdev']:.0f}")

    # Monthly scores
    print(f"\n{'='*80}")
    print("MONTHLY COMPOSITE SCORES")
    print(f"{'='*80}")
    print(f"  {'Month':<10} {'Prompts':>8} {'Mean':>8} {'Median':>8} {'Stdev':>8} {'Trend':>8}")
    print(f"  {'-'*50}")
    prev_mean = None
    for month in sorted(results["by_month"].keys()):
        data = results["by_month"][month]
        scores = data["scores"]
        mean_val = statistics.mean(scores)
        median_val = statistics.median(scores)
        stdev_val = statistics.stdev(scores) if len(scores) > 1 else 0
        trend = ""
        if prev_mean is not None:
            diff = mean_val - prev_mean
            trend = f"+{diff:.2f}" if diff > 0 else f"{diff:.2f}"
        prev_mean = mean_val
        print(f"  {month:<10} {data['count']:>8} {mean_val:>8.2f} {median_val:>8.2f} {stdev_val:>8.2f} {trend:>8}")

    # Project scores
    print(f"\n{'='*80}")
    print("PROJECT COMPOSITE SCORES (sorted by mean)")
    print(f"{'='*80}")
    print(f"  {'Project':<35} {'Prompts':>8} {'Mean':>8} {'Median':>8}")
    print(f"  {'-'*60}")
    project_items = [(k, v) for k, v in results["by_project"].items() if v["count"] >= 10]
    project_items.sort(key=lambda x: statistics.mean(x[1]["scores"]), reverse=True)
    for project, data in project_items:
        scores = data["scores"]
        mean_val = statistics.mean(scores)
        median_val = statistics.median(scores)
        print(f"  {project:<35} {data['count']:>8} {mean_val:>8.2f} {median_val:>8.2f}")

    # Project x Month matrix (top projects only)
    top_projects = [p for p, _ in project_items[:8]]
    if top_projects:
        print(f"\n{'='*80}")
        print("PROJECT x MONTH SCORES (top projects, >=5 prompts)")
        print(f"{'='*80}")
        months = sorted(results["by_month"].keys())
        print(f"  {'Project':<25}", end="")
        for m in months:
            print(f" {m[5:]:>7}", end="")
        print()
        print(f"  {'-'*25}", end="")
        for _ in months:
            print(f" {'-'*7}", end="")
        print()
        for project in top_projects:
            print(f"  {project:<25}", end="")
            for m in months:
                mdata = results["by_project"][project]["months"].get(m)
                if mdata and mdata["count"] >= 3:
                    print(f" {statistics.mean(mdata['scores']):>7.2f}", end="")
                else:
                    count = mdata["count"] if mdata else 0
                    print(f" {'---':>7}" if count == 0 else f" {f'({count})':>7}", end="")
            print()

    # Workspace scores
    print(f"\n{'='*80}")
    print("WORKSPACE SCORES")
    print(f"{'='*80}")
    for ws, data in sorted(results["by_workspace"].items(), key=lambda x: -statistics.mean(x[1]["scores"])):
        if data["count"] >= 5:
            print(f"  {ws:<20} {data['count']:>6} prompts  mean={statistics.mean(data['scores']):.2f}")

    # Top 20 best prompts
    print(f"\n{'='*80}")
    print("TOP 10 HIGHEST-SCORING PROMPTS")
    print(f"{'='*80}")
    for i, p in enumerate(results["top_prompts"][:10], 1):
        print(f"\n  #{i} (score: {p['score']:.2f}) [{p['month']}] [{p['project']}]")
        print(f"  {p['text'][:150]}")

    # Bottom 10 worst prompts (excluding commands and ultra-terse)
    print(f"\n{'='*80}")
    print("BOTTOM 10 LOWEST-SCORING PROMPTS (excluding slash commands)")
    print(f"{'='*80}")
    worst_filtered = [p for p in results["worst_prompts"] if not p["text"].startswith("/") and len(p["text"].split()) > 2]
    for i, p in enumerate(worst_filtered[:10], 1):
        print(f"\n  #{i} (score: {p['score']:.2f}) [{p['month']}] [{p['project']}]")
        print(f"  {p['text'][:150]}")


# ─── Outcome Correlation ────────────────────────────────────────────────────
# Joins prompt quality scores with session outcome data from Claude Code's
# /insights pipeline (session-meta + facets).

USAGE_DATA = Path.home() / ".claude" / "usage-data"
SESSION_META_DIR = USAGE_DATA / "session-meta"
FACETS_DIR = USAGE_DATA / "facets"

# Outcome quality tiers (higher = better)
OUTCOME_SCORES = {
    "fully_achieved": 4,
    "mostly_achieved": 3,
    "partially_achieved": 2,
    "not_achieved": 1,
    "unclear_from_transcript": None,  # excluded
}

HELPFULNESS_SCORES = {
    "essential": 5,
    "very_helpful": 4,
    "moderately_helpful": 3,
    "slightly_helpful": 2,
    "unhelpful": 1,
}


def load_session_outcomes():
    """Load session-meta and facets, return dict keyed by session_id."""
    sessions = {}

    # Load facets (outcome labels)
    if not FACETS_DIR.exists():
        return sessions
    for f in FACETS_DIR.glob("*.json"):
        try:
            d = json.load(open(f))
            sid = d.get("session_id", f.stem)
            sessions[sid] = {
                "outcome": d.get("outcome", "unknown"),
                "outcome_score": OUTCOME_SCORES.get(d.get("outcome"), None),
                "helpfulness": d.get("claude_helpfulness", "unknown"),
                "helpfulness_score": HELPFULNESS_SCORES.get(d.get("claude_helpfulness"), None),
                "session_type": d.get("session_type", "unknown"),
                "friction_counts": d.get("friction_counts", {}),
                "total_friction": sum(d.get("friction_counts", {}).values()),
                "friction_types": list(d.get("friction_counts", {}).keys()),
                "goal": d.get("underlying_goal", ""),
                "summary": d.get("brief_summary", ""),
            }
        except (json.JSONDecodeError, ValueError):
            continue

    # Enrich with session-meta (quantitative signals)
    if SESSION_META_DIR.exists():
        for f in SESSION_META_DIR.glob("*.json"):
            try:
                d = json.load(open(f))
                sid = d.get("session_id", f.stem)
                if sid not in sessions:
                    continue  # only enrich sessions that have facets
                sessions[sid].update({
                    "duration_minutes": d.get("duration_minutes", 0),
                    "user_messages": d.get("user_message_count", 0),
                    "assistant_messages": d.get("assistant_message_count", 0),
                    "tool_errors": d.get("tool_errors", 0),
                    "user_interruptions": d.get("user_interruptions", 0),
                    "lines_added": d.get("lines_added", 0),
                    "lines_removed": d.get("lines_removed", 0),
                    "files_modified": d.get("files_modified", 0),
                    "input_tokens": d.get("input_tokens", 0),
                    "output_tokens": d.get("output_tokens", 0),
                    "response_times": d.get("user_response_times", []),
                })
            except (json.JSONDecodeError, ValueError):
                continue

    return sessions


def correlate_prompts_with_outcomes(prompts, sessions):
    """Join prompt scores with session outcomes. Returns correlation data."""
    # Group prompts by session
    session_prompts = defaultdict(list)
    for p in prompts:
        sid = p.get("session_id", "")
        if sid and sid in sessions:
            ptype = classify_prompt_type(p["text"])
            if ptype not in EXEMPT_TYPES:
                scores = score_prompt(p["text"])
                session_prompts[sid].append({
                    "text": p["text"][:200],
                    "scores": scores,
                    "word_count": p["word_count"],
                })

    # Build per-session aggregates
    correlated = []
    for sid, prompt_list in session_prompts.items():
        if not prompt_list:
            continue
        session = sessions[sid]
        if session.get("outcome_score") is None:
            continue  # skip unclear outcomes

        composites = [p["scores"]["composite"] for p in prompt_list]
        dim_means = {}
        for dim in DIMENSIONS:
            dim_means[dim] = statistics.mean([p["scores"][dim] for p in prompt_list])

        correlated.append({
            "session_id": sid,
            "prompt_count": len(prompt_list),
            "prompt_mean": statistics.mean(composites),
            "prompt_median": statistics.median(composites),
            "prompt_max": max(composites),
            "dim_means": dim_means,
            "outcome": session["outcome"],
            "outcome_score": session["outcome_score"],
            "helpfulness": session["helpfulness"],
            "helpfulness_score": session.get("helpfulness_score"),
            "session_type": session["session_type"],
            "total_friction": session["total_friction"],
            "friction_types": session["friction_types"],
            "tool_errors": session.get("tool_errors", 0),
            "user_interruptions": session.get("user_interruptions", 0),
            "duration_minutes": session.get("duration_minutes", 0),
            "lines_added": session.get("lines_added", 0),
            "files_modified": session.get("files_modified", 0),
            "goal": session["goal"],
            "summary": session["summary"],
        })

    return correlated


def compute_correlations(correlated):
    """Compute Spearman rank correlations between prompt scores and outcomes."""
    if len(correlated) < 5:
        return {}

    # Extract arrays
    prompt_means = [c["prompt_mean"] for c in correlated]
    outcome_scores = [c["outcome_score"] for c in correlated]
    friction_scores = [c["total_friction"] for c in correlated]
    tool_errors = [c["tool_errors"] for c in correlated]

    def spearman(x, y):
        """Simple Spearman rank correlation (no scipy dependency)."""
        n = len(x)
        if n < 3:
            return 0.0
        # Rank the values
        def rank(arr):
            indexed = sorted(enumerate(arr), key=lambda t: t[1])
            ranks = [0.0] * n
            i = 0
            while i < n:
                j = i
                while j < n - 1 and indexed[j + 1][1] == indexed[j][1]:
                    j += 1
                avg_rank = (i + j) / 2.0 + 1
                for k in range(i, j + 1):
                    ranks[indexed[k][0]] = avg_rank
                i = j + 1
            return ranks

        rx = rank(x)
        ry = rank(y)
        d_sq = sum((rx[i] - ry[i]) ** 2 for i in range(n))
        return 1 - (6 * d_sq) / (n * (n * n - 1))

    results = {
        "prompt_vs_outcome": spearman(prompt_means, outcome_scores),
        "prompt_vs_friction": spearman(prompt_means, [-f for f in friction_scores]),  # negate: less friction = better
        "prompt_vs_tool_errors": spearman(prompt_means, [-e for e in tool_errors]),
    }

    # Per-dimension correlations with outcome
    for dim in DIMENSIONS:
        dim_vals = [c["dim_means"][dim] for c in correlated]
        results[f"{dim}_vs_outcome"] = spearman(dim_vals, outcome_scores)
        results[f"{dim}_vs_friction"] = spearman(dim_vals, [-f for f in friction_scores])

    return results


def print_outcome_report(correlated, correlations):
    """Print outcome correlation analysis."""
    print(f"\n{'='*80}")
    print("OUTCOME CORRELATION (prompt quality → session results)")
    print(f"{'='*80}")
    print(f"\nSessions with outcome data: {len(correlated)}")

    if len(correlated) < 5:
        print("  Insufficient data for correlation analysis (need ≥5 sessions)")
        return

    # Outcome distribution
    outcomes = defaultdict(list)
    for c in correlated:
        outcomes[c["outcome"]].append(c["prompt_mean"])

    print(f"\n  {'Outcome':<25} {'Sessions':>8} {'Prompt Mean':>12} {'Friction':>10}")
    print(f"  {'-'*25} {'-'*8} {'-'*12} {'-'*10}")
    for outcome in ["fully_achieved", "mostly_achieved", "partially_achieved", "not_achieved"]:
        sessions = [c for c in correlated if c["outcome"] == outcome]
        if sessions:
            pm = statistics.mean([c["prompt_mean"] for c in sessions])
            fr = statistics.mean([c["total_friction"] for c in sessions])
            print(f"  {outcome:<25} {len(sessions):>8} {pm:>12.2f} {fr:>10.1f}")

    # Correlations
    print(f"\n  Spearman Rank Correlations (n={len(correlated)})")
    print(f"  {'-'*55}")

    def interpret(r):
        ar = abs(r)
        if ar < 0.1:
            return "negligible"
        elif ar < 0.3:
            return "weak"
        elif ar < 0.5:
            return "moderate"
        elif ar < 0.7:
            return "strong"
        else:
            return "very strong"

    print(f"\n  Composite score correlations:")
    for key in ["prompt_vs_outcome", "prompt_vs_friction", "prompt_vs_tool_errors"]:
        r = correlations.get(key, 0)
        label = key.replace("prompt_vs_", "prompt quality → ")
        print(f"    {label:<40} r={r:>+.3f}  ({interpret(r)})")

    print(f"\n  Per-dimension → outcome:")
    dim_corrs = [(dim, correlations.get(f"{dim}_vs_outcome", 0)) for dim in DIMENSIONS]
    dim_corrs.sort(key=lambda x: abs(x[1]), reverse=True)
    for dim, r in dim_corrs:
        print(f"    {dim:<20} → outcome    r={r:>+.3f}  ({interpret(r)})")

    print(f"\n  Per-dimension → less friction:")
    dim_corrs = [(dim, correlations.get(f"{dim}_vs_friction", 0)) for dim in DIMENSIONS]
    dim_corrs.sort(key=lambda x: abs(x[1]), reverse=True)
    for dim, r in dim_corrs:
        print(f"    {dim:<20} → less friction  r={r:>+.3f}  ({interpret(r)})")

    # Session type breakdown
    print(f"\n  By session type:")
    by_type = defaultdict(list)
    for c in correlated:
        by_type[c["session_type"]].append(c)
    print(f"  {'Type':<25} {'N':>4} {'Prompt':>8} {'Outcome':>8} {'Friction':>8}")
    print(f"  {'-'*25} {'-'*4} {'-'*8} {'-'*8} {'-'*8}")
    for stype, sessions in sorted(by_type.items(), key=lambda x: -len(x[1])):
        if len(sessions) >= 2:
            pm = statistics.mean([c["prompt_mean"] for c in sessions])
            om = statistics.mean([c["outcome_score"] for c in sessions])
            fr = statistics.mean([c["total_friction"] for c in sessions])
            print(f"  {stype:<25} {len(sessions):>4} {pm:>8.2f} {om:>8.2f} {fr:>8.1f}")

    # Friction type analysis — which friction types correlate with low prompt scores?
    friction_types_seen = defaultdict(list)
    for c in correlated:
        for ft in c["friction_types"]:
            friction_types_seen[ft].append(c["prompt_mean"])
    no_friction = [c["prompt_mean"] for c in correlated if c["total_friction"] == 0]

    if friction_types_seen:
        print(f"\n  Prompt quality by friction type:")
        print(f"  {'Friction Type':<30} {'Sessions':>8} {'Prompt Mean':>12}")
        print(f"  {'-'*30} {'-'*8} {'-'*12}")
        if no_friction:
            print(f"  {'(no friction)':<30} {len(no_friction):>8} {statistics.mean(no_friction):>12.2f}")
        for ft, scores in sorted(friction_types_seen.items(), key=lambda x: statistics.mean(x[1])):
            if len(scores) >= 2:
                print(f"  {ft:<30} {len(scores):>8} {statistics.mean(scores):>12.2f}")

    # Top insight: which dimension gap predicts the most friction?
    print(f"\n  KEY FINDING:")
    # Find the dimension with strongest negative correlation to friction
    best_dim = None
    best_r = 0
    for dim in DIMENSIONS:
        r = correlations.get(f"{dim}_vs_friction", 0)
        if r > best_r:  # positive r = higher dim score → less friction
            best_r = r
            best_dim = dim
    if best_dim and abs(best_r) > 0.1:
        dim_mean = statistics.mean([c["dim_means"][best_dim] for c in correlated])
        print(f"  Improving '{best_dim}' (currently {dim_mean:.1f}/10) has the strongest")
        print(f"  correlation with reduced friction (r={best_r:+.3f}).")
        print(f"  Sessions where {best_dim} > {dim_mean:.0f} had"
              f" {statistics.mean([c['total_friction'] for c in correlated if c['dim_means'][best_dim] > dim_mean]):.1f}"
              f" avg friction vs"
              f" {statistics.mean([c['total_friction'] for c in correlated if c['dim_means'][best_dim] <= dim_mean]):.1f}"
              f" when ≤ {dim_mean:.0f}.")
    else:
        print("  No strong dimension-friction correlation found in current data.")


def main():
    print(f"Loading prompts from {HISTORY_FILE}...")
    prompts = load_prompts(HISTORY_FILE)
    print(f"Loaded {len(prompts)} prompts")

    results = analyze(prompts)
    print_report(results)

    # Outcome correlation
    sessions = load_session_outcomes()
    if sessions:
        correlated = correlate_prompts_with_outcomes(prompts, sessions)
        if correlated:
            correlations = compute_correlations(correlated)
            print_outcome_report(correlated, correlations)
        else:
            print(f"\n(No sessions could be linked to prompts for outcome correlation)")
    else:
        print(f"\n(No session outcome data found at {FACETS_DIR})")


if __name__ == "__main__":
    main()
