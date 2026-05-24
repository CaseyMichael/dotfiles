# Root-Cause Playbook

Produce a hypothesis for *why* the trace failed or was slow, grounded in span data + correlated logs.

## Steps

1. **Find the first anomalous span in causal order.** Walk spans top-down by start time. Stop at the first span that errored or dominated latency.
   - For errors: first span with `error=true` (not the deepest — its child error may just be propagation).
   - For latency: span with the largest self-time (duration minus child time), not the longest total time.

2. **Examine that span's tags and logs.**
   - Tags of interest: `error.type`, `error.message`, `error.stack`, `http.status_code`, `db.statement`, `peer.service`, `out.host`, `resource_name`.
   - Logs: filter the cached log sample to entries within the span's time window. If the cache doesn't show a clear log message tied to the span, expand the log query (`search_datadog_logs` with a tighter time range around `start_time`).

3. **Form a hypothesis.** State it in the form: "X failed/was slow because Y, based on Z evidence."
   - Cite the span name, the specific tag/log line, and the time.
   - If evidence is thin, say so explicitly ("Hypothesis is tentative — no log message accompanied the failing span").

4. **Stop.** Do not propose fixes. Do not write code. The hypothesis is the deliverable.

## Anti-patterns

- Hypothesis without an evidence pointer (which span, which tag, which log).
- Picking the deepest error span instead of the first one in causal order.
- Treating "longest total duration" as the latency hotspot when self-time tells a different story.
