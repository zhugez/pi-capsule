---
name: long-form-research-delivery
description: "Use when reports are long. Write Markdown; keep chat brief."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [research, reports, markdown, file-delivery, telegram, cron]
---

# Long-form research delivery

Use this workflow for research summaries, video/article digests, market briefs, repository analyses, and recurring reports when the result would be more than a few short chat paragraphs.

## Always-on rules

- Match the user's language; for this user, default to Vietnamese unless requested otherwise.
- Deliver long content as a readable `.md` file, not as a wall of chat text. Use a short chat message with a file link/attachment instead.
- Preserve evidence metadata in the file: source URLs, collection timestamp and timezone, scope of data, observed facts, interpretation, uncertainty, and unverified claims.
- Separate raw/observed data from analysis. Never turn a market-implied probability, social-media claim, transcript inference, or model output into an established fact.
- After creating the file, do not paste the same full report into chat. Keep the chat handoff to a few highlights and the absolute `MEDIA:/...` path when the platform supports native file delivery.
- Verify the artifact exists and is non-empty before claiming delivery.

## Procedure

1. **Classify the deliverable.** Use a Markdown file when the result contains a timeline, table, citations, transcript-derived detail, multiple sections, a recurring brief, or more than a few chat paragraphs. Keep only a concise executive summary in chat.
2. **Collect and normalize evidence.** For internet/social/video tasks, use the applicable fetch skill first. Record the exact URL(s), source type, timestamp, timezone, and whether the content was directly observed, transcribed, extracted, or inferred.
3. **Draft for reading.** Use headings, a short executive summary, bullets/tables where useful, and a final uncertainty/limitations section. For long videos, include duration, transcript method, important timestamp ranges, and any ASR uncertainty. If caption and spoken content disagree, preserve the discrepancy instead of silently choosing one.
4. **Write the file.** For known content, use `write_file` to an absolute path. For recurring jobs, use a date/time-stamped path under the job's configured output directory, e.g. `/home/dev/.hermes/cron/output/<job-id>/YYYY-MM-DD_HH-mm-ss.md`.
5. **Verify the file.** Check that the path exists, the size is non-zero, and the first section contains the expected title/source. When transforming a scheduler wrapper, extract the actual response section and remove prompt text, skill warnings, and cron metadata before sharing the cleaned report.
6. **Deliver briefly.** State what was created, mention one or two important caveats, and attach/link the Markdown file. A recurring report prompt must explicitly tell the scheduled agent to write the full report first and make its final response only a short summary plus `MEDIA:/absolute/path/to/report.md`.

## Recurring-report guardrails

- Keep the full report out of Telegram/chat even when the scheduler automatically delivers the agent's final response.
- If a required skill is missing, do not emit a long fallback report with a missing-skill warning. Either restore/use an available workflow or embed the necessary source, safety, timestamp, and uncertainty rules in the job prompt; then keep the output-file contract unchanged.
- Preserve read-only, no-trade, no-post, authorization, and secret-redaction constraints from the task's domain skill while changing only the delivery format.

## Common pitfalls

- Do not treat a successful scheduler run as proof that the report was delivered in the desired format; inspect the generated artifact and final delivery contract.
- Do not share the scheduler's raw wrapper file when it contains the prompt, tool warnings, or internal metadata; create a cleaned Markdown copy first.
- Do not create a new skill or reference file for each report date. Extend this class-level workflow when a reusable delivery lesson appears.
