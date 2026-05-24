---
name: investigate-datadog-trace
description: Use when the user shares a Datadog trace URL/ID or a Datadog error-tracking issue URL and wants to investigate it. Triggered by pasted `app.datadoghq.com/apm/trace/...` links, pasted `app.datadoghq.com/error-tracking/...` links, bare trace IDs in context of a request to investigate, or phrases like "investigate this trace", "what's going on in this trace", "look into this error".
---

# Investigate Datadog Trace

## Overview

Turn a trace URL/ID or error-tracking issue URL into a grounded investigation.

**Two phases, strictly ordered:**

1. **Ground.** Parse input, fetch the trace + correlated logs in parallel, summarize the facts, cache for the session.
2. **Direct.** Propose 1–2 *specific* investigations grounded in Phase 1 facts. User picks. Load the matching reference playbook from `references/` and execute.

Never propose "want me to investigate?" — always propose a concrete action ("want me to root-cause this DB timeout?").

Out of scope: proposing fixes, writing code, filing tickets, posting messages, running app code, reproducing locally.

## Phase 1: Ground

### Parse input

Accept any of:

- **Trace URL** — `app.datadoghq.com/apm/trace/<trace_id>?...`. Extract `trace_id`.
- **Bare trace ID** — hex or decimal string in a clear "investigate" context.
- **Error-tracking URL** — `app.datadoghq.com/error-tracking/...issue/<issue_id>`. Call `get_datadog_error_tracking_issue(issue_id)`, then pick a representative trace_id from a recent error sample.

If input is ambiguous or missing, ask once for the trace ID or URL.

### Discover Datadog skills

Before any other Datadog MCP calls, in **parallel**:

- `load_datadog_skill(skill_name='datadog/traces')`
- `list_datadog_skills(query='trace investigation')` — load any clearly matching result

**Skip discovery** if a sibling skill in the same session already loaded `datadog/traces`.

### Fetch trace + logs

In **parallel**:

- `get_datadog_trace(trace_id=<id>)`
- `search_datadog_logs` filtered by `trace_id:<id>` — fetch a small sample (last ~20 log events for the trace)

### Summarize (4–8 lines)

Print a terse summary covering:

- Root service + endpoint, total duration, HTTP status if applicable
- **First** error span in causal order (not the deepest): service, operation, error type, error message
- Latency hotspot: longest span(s) by self-time
- Useful trace tags: `env`, `version`, `user.id`, `org.id` if present
- Direct link back to the trace in Datadog
- One-line note on log sample (e.g., "20 logs, 3 ERROR-level around the failing span")

### Cache for session

Hold the raw trace, log sample, and summary in conversation context. Phase 2 investigations reuse these — do not re-fetch unless the user expands the scope (e.g., longer log window).

**Phase 1 ends with the printed summary. No investigation yet.**

## Phase 2: Direct

After the Phase 1 summary, propose **1–2 concrete investigations** derived from what the summary shows. Each proposal must be a specific action the user can accept or redirect.

### Proposal mapping

| Phase 1 finding | Propose |
| --- | --- |
| Error span with stack in lattice code | root-cause + code-link |
| Error span in third-party / framework code | root-cause + pattern-check |
| Slow trace, no errors | root-cause (latency angle) and/or pattern-check |
| From error tracking, high occurrence count | pattern-check first, then root-cause |

### Execute

When the user picks a direction (including mid-Phase-1 redirects), read the matching playbook and follow it:

- `references/root-cause.md`
- `references/code-linking.md`
- `references/pattern-check.md`

Investigations are independent and chainable. The user can run one, stop, or chain (e.g., root-cause → code-link → pattern-check). The cached trace + logs serve all of them.

### Rules

- Never propose generic "want to investigate?" — always concrete and bounded.
- Never propose fixes, never write code, never file tickets, never call `/write-ticket`.
- If the user wants a ticket from the findings, they'll invoke `/write-ticket` separately — the conversation already carries the context.
- If a Datadog MCP call fails (auth, 404, org error), surface the raw error and stop. Do not fabricate.
