# Prompt Engineering Self-Assessment

Copy everything below the line and paste it as your first message in a new Claude Code session.

---

Analyze my prompt engineering quality by examining my Claude Code history. Do NOT look at CLAUDE.md files — focus exclusively on what I actually type as prompts and how I interact with Claude.

## Step 1: Extract and analyze my prompt history

Read the file `~/.claude/history.jsonl`. Each line is JSON with fields: `display` (my prompt text), `timestamp` (ms), `project` (path), `sessionId`.

Write and run a Python script that:

1. Loads all prompts from history.jsonl
2. For each prompt, scores it on 5 research-backed dimensions (1-10, no signal overlap):
   - **Intent** (20%): action verbs present, identifiable target, word count thresholds
   - **Context** (25%): file paths/extensions, code blocks, backtick refs, error messages, function/component refs
   - **Specificity** (20%): assertive language ("must", "never", "exactly") vs vague ("something", "better"), concrete values, named behaviors
   - **Scope** (15%): constraints ("don't", "only"), decomposition (bullets/numbers/headers) for multi-concern prompts, neutral baseline for simple single-concern prompts
   - **Verifiability** (20%): expected output defined ("should return", "done when"), verification commands ("run npm test"), format requests, example I/O
3. Composite = weighted average of the 5 dimensions (weights above)
4. Exempt categories excluded from scoring: execution confirmations ("yes", "go ahead"), slash commands, follow-up questions (≤8 words with ?), continuations ("now do the same for..."), corrections ("no, I meant..."), acknowledgments ("thanks", "got it")
5. Classifies each prompt type: ultra-terse (<=2 words), terse (3-5), question (?), feature (add/create/implement), bug-fix (fix/error/broken), review, testing, deploy, refactor, research, command (/), execution, followup, continuation, correction, acknowledgment, general
5. Extracts project name from path (2nd-level folder under the projects directory)
6. Extracts month from timestamp

Output these tables:
- Overall: total prompts, date range, composite mean/median/stdev, ultra-terse %, dimension averages
- Monthly: month, prompts, composite mean/median, trend vs previous month
- Monthly behavioral: corrections (prompts containing "no"/"wrong"/"not that"/"instead"/"actually"/"stop"), verifications ("verify"/"check"/"test"/"confirm"/"validate"/"make sure"), questions (ending with ?), file references (containing file extensions or /), ultra-terse %
- Per project (>=10 prompts): project, prompts, composite mean/median, sorted by mean descending
- Project x month matrix (>=5 prompts in cell): mean composite scores
- Per workspace: workspace, prompts, mean
- Session distribution: group by sessionId, show how many sessions have 1-5, 6-10, 11-20, 21-50, 50+ prompts
- Top 10 highest-scoring prompts (show text truncated to 150 chars, score, month, project)
- Top 10 lowest-scoring prompts excluding slash commands and <=2 word prompts
- Top 15 most common ultra-terse prompts (<=3 words) with counts
- Prompt length stats: character mean/median, word mean/median

## Step 2: Qualitative conversation sampling

Find the 3 largest .jsonl files in `~/.claude/projects/` subdirectories (these are full conversation sessions). For each, extract user messages (type=="user", isMeta!=true, text not starting with "<").

Analyze across the sampled sessions:
- **Opening pattern**: How do I start sessions? (dense context dump, terse jump-in, reconnaissance first?)
- **Delegation pattern**: How often do I use ultra-terse responses ("yes", "go", "do it", "next")? As what % of turns?
- **Correction pattern**: When Claude gets something wrong, how do I correct? (retry same prompt, reword with specifics, escalate to root-cause analysis, structural reset?)
- **Failure handling**: After 2+ retries, do I escalate or keep retrying? Do I ever revert and restart clean?
- **Verification habit**: Do I verify Claude's output between steps, or only at milestones?
- **Quality variance**: What's the gap between my best and worst prompt in a single session?
- **Session scope**: Does the session stay focused or drift across multiple tasks?
- Quote specific examples of my best and worst prompts from the conversations.

## Step 3: Synthesize the assessment

Write a comprehensive assessment to `prompt-engineering-assessment.md` in the current directory, containing:

### Section 1: Overall Score
- Composite mean and median on 1-10 scale
- All 5 dimension scores with interpretation
- Estimated percentile (use: <3.5 = bottom 30%, 3.5-4.5 = 30-50th, 4.5-5.5 = 50-70th, 5.5-6.5 = 70-85th, 6.5-7.5 = 85-95th, >7.5 = top 5%)
- Prompt type distribution
- Length statistics

### Section 2: Monthly Trajectory
- Monthly composite scores with trend arrows
- Monthly behavioral metrics (corrections, verifications, questions, file refs, ultra-terse %)
- Identify: are corrections going down? verifications going up? questions increasing? (healthy signals)

### Section 3: Project Scores
- Ranked project list with scores
- Project x month matrix
- Workspace comparison
- Which project has the best/worst prompts and why

### Section 4: Qualitative Patterns
- What I do well (with quoted examples from my actual prompts)
- What I do poorly (with quoted examples)
- My core interaction pattern (the sequence of good/bad habits)
- The gap between my best prompt score and my average

### Section 5: Study Plan
- Prioritized list of 5-7 skills to improve, ordered by impact
- Each skill gets: current score, target score, specific before/after example from MY data, practice exercise, timeline
- Monthly KPI targets for: composite, structure, file ref %, verification %, ultra-terse %

### Section 6: Tracking
- Save the Python analysis script as `analyze-prompts.py` in the current directory
- Include instructions to re-run monthly: `python3 analyze-prompts.py`
- Assessment history table (this run as baseline)

## Constraints

- Use ONLY my actual prompt data — do not score CLAUDE.md, rules files, or memory files
- Quote my real prompts as examples (best and worst) — do not invent examples
- Be honest and direct — if my prompts are bad, say so with the data
- Run at least 2 iterations: first pass for raw scoring, second pass to cross-validate dimensions against qualitative findings
- The Python script must be self-contained and re-runnable
