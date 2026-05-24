# Pattern-Check Playbook

Decide whether the failure/slowness is one-off or systemic.

## Window

Default 24h. Widen only if the user asks or if Phase 1 came from an error-tracking issue with a known longer occurrence history (in which case use the issue's reported window).

## Steps

1. **Define "similar".** From the failing/slow span:
   - Same `service`
   - Same `operation_name` or `resource_name`
   - Same `error.type` (if errored)

2. **Aggregate.** Use `aggregate_spans` with the filter above. Group by `user.id` or `org.id` if those tags are present on the original trace; otherwise group by `service` only.

3. **Spot-check examples.** Use `search_datadog_spans` (limit ~5) to pull a few example trace IDs across the window, to verify the aggregate isn't being skewed by a single odd trace.

4. **Report.**
   - **Count:** number of matching spans / traces over the window.
   - **Affected users/orgs:** distinct count if `user.id` / `org.id` grouping is available.
   - **Time distribution:** burst (clustered in minutes) vs steady (spread across hours) vs single occurrence.
   - **Conclusion:** "one-off within last 24h" / "recurring but low-volume (N/day)" / "systemic (N/hour, M users affected)".

5. **Zero-hit handling.** If the aggregate returns 0 (or only the original trace), conclude "one-off within window" — do not pad with unrelated data.

## Anti-patterns

- Reporting raw aggregate numbers without the one-off / recurring / systemic verdict.
- Widening the window silently to make a count look more impressive.
- Counting spans when the question is about *traces* (de-dup if needed).
