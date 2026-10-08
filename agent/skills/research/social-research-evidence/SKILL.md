---
name: social-research-evidence
description: "Use for social research. Preserve provenance and evidence."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [research, social, reddit, community, evidence, provenance]
---

# Social/community research with evidence discipline

Use this class-level workflow when the user wants community sentiment, reviews, use cases, configuration advice, or discussion trends from Reddit or another social platform.

## Always-on rules

- Use the platform-specific fetch skill first. For Reddit and other login-backed platforms, run the platform router/doctor before searching and announce the backend and transport.
- Never describe an indexed search result, cached page, or public web extraction as direct authenticated platform browsing. State whether each source was fully fetched, partially fetched, or snippet-only.
- Separate four evidence layers in the notes and final report:
  1. **Observed community report:** what a named thread/comment claims to have experienced.
  2. **Provider or vendor claim:** official documentation, launch post, pricing, or benchmark claim.
  3. **Independent measurement:** reproducible experiment, telemetry, test result, or controlled comparison.
  4. **Analyst synthesis:** the cautious conclusion drawn from the first three layers.
- Do not turn sentiment, upvotes, one user's result, or a model's self-report into an objective ranking. Report disagreement and likely confounders such as task type, prompt, context, tools, serving mode, effort, plan, quota, and rollout timing.
- Preserve exact permalinks, collection timestamp/timezone, retrieval method, query scope, and limitations. Do not fabricate comment counts, vote counts, sample sizes, or sentiment percentages.
- For model/settings research, distinguish model selection from workflow design: task decomposition, context packet quality, tool loops, retries, tests, and review often dominate the apparent model difference.
- Match the user's language; for this user, write Vietnamese unless requested otherwise. For a long result, use the long-form Markdown delivery skill and keep chat to a short summary plus the file attachment/link.

## Procedure

1. **Define the research question.** Split it into model/product identity, community experience, use cases, settings, and caveats. Preserve version names literally; do not silently normalize aliases such as `GPT-6`, `GPT-6 Sol`, and `GPT-5.6 Sol`.
2. **Health-check and route.** Run the applicable agent-reach doctor command before using Reddit. Select the reported active backend and follow its documented retry chain. If no direct backend is available, use public indexed pages only as a fallback and mark the limitation before synthesis.
3. **Search in parallel.** Use exact-name searches, model-versus-model searches, use-case terms, settings/effort terms, and negative/failure terms. Include both the target community and adjacent communities only when the source context remains clear.
4. **Collect a balanced sample.** Gather launch reactions, positive reports, negative reports, controlled comparisons, and workflow/configuration threads. Prefer full thread pages and primary comments; retain snippets only as leads or clearly labeled weak evidence.
5. **Normalize each source.** Record: permalink, subreddit/platform, thread title, author if relevant, relative/absolute date as displayed, full-page vs partial vs snippet, claim type, task context, model/setting, and whether a test or artifact is available.
6. **Cross-check against primary documentation.** Fetch official model/API documentation when discussing capabilities, pricing, supported effort levels, context limits, or availability. Label official benchmark numbers as provider claims rather than independent proof.
7. **Synthesize by convergence and disagreement.** State what multiple independent reports agree on, then list meaningful counterexamples. Explain confounders before deciding that a model is better or worse.
8. **Recommend settings conditionally.** Give presets by task class, not one universal winner. Include an escalation rule, a stop condition for repeated failures, and mandatory validation such as tests, diff review, or reproduction.
9. **Write the report.** Use a Markdown artifact with an executive summary, method/coverage, evidence-layered findings, use-case matrix, settings presets, source list, and limitations. Keep raw community claims visibly separate from analyst conclusions.
10. **Run the router's update check when required.** After a substantial multi-platform research task, run the fetch skill's update check and mention an available update without interrupting the current report.

## Recommended report structure

```markdown
# Topic — community research brief

## Executive summary
## Collection method and coverage
## What the community reports
### Positive evidence
### Negative evidence
### Disagreement and confounders
## Official/provider claims
## Independent measurements
## Use-case matrix
## Settings/presets with escalation rules
## Analyst synthesis
## Unverified claims and limitations
## Source list with retrieval method
```

## Common pitfalls

- Do not claim “Reddit research” from one search result; a search index can omit deleted comments, rank selectively, and expose stale snippets.
- Do not merge adjacent model generations in one conclusion; a GPT-5.6 result is useful context but is not evidence about GPT-6 behavior.
- Do not recommend `max`/`xhigh` merely because it sounds stronger; compare latency, repair loops, tool calls, quota burn, and accepted-task quality.
- Do not treat a benchmark on a bounded or potentially memorized task as proof of repo-level reliability; require evidence about ambiguity, conventions, retries, and final validation.
- Do not hide backend limitations in a footnote; the transport determines how much confidence a community-sentiment conclusion deserves.
- Do not paste a long social-research report into chat when the user has requested readable Markdown delivery; attach the artifact and summarize only the decision-relevant points.
