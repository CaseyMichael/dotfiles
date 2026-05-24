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
