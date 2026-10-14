---
name: epic-status-update
description: Write the weekly (Wednesday) "Status updates" entry on a Jira epic and post it to the epic. Use whenever Casey gives a Jira epic link or key (e.g. PD-122384) and asks for a status update, weekly update, epic update, "what got done this week", or risk/blocker check against the epic's due date. Looks at child tickets completed in the past week, drafts the entry, shows it for approval, then prepends it to the field.
---

# Epic weekly status update

Jira site: `latticehr.atlassian.net`. Use the `mcp__jira__*` tools (load via ToolSearch if deferred).

## Fields (PD project)

| Field | ID | Notes |
|---|---|---|
| Status updates | `customfield_10315` | plain text, newest entry first |
| Status (RAG) | `customfield_10323` | select: `🟢 On track`, other options exist; read editmeta before changing |
| Due date | `duedate` | the date risk is measured against |
| Start date | `customfield_10123` | |
| Story Points | `customfield_10078` | on child tickets; 1 point = 1 day of work |

## Steps

1. Parse the epic key from the link. Fetch it with fields `summary,status,duedate,customfield_10315,customfield_10323,customfield_10123`.
2. Fetch children: JQL `parent = <KEY> ORDER BY status`, fields `summary,status,assignee,resolutiondate,updated,customfield_10078`. Request `maxResults: 100` and page if needed.
3. Split children:
   - Done last 7 days: statusCategory Done and `resolutiondate` within 7 days of today. Window is the previous Wednesday to today; confirm if the existing latest entry date implies a different window.
   - In progress / in review.
   - Not started (remaining count).
4. Judge blockers: tickets in a blocked status or with a blocked flag/label, tickets with no movement in more than 7 days while In Progress, or anything the existing entry listed as a blocker that is still open. Check recent comments on in-progress tickets only if status alone is ambiguous.
5. Judge risk against `duedate`: story points are days of work, so sum the points of every not-done child (an in-review ticket counts in full, conservatively) and compare with the working days left from today to `duedate` (exclude weekends). Never judge by ticket count or milestone count, since tickets differ a lot in size (a 2-day ticket is not a 5-day ticket). Remaining days at or under working days left is "on track"; over by a small margin is "at risk"; well over is "off track". Do the math silently. When on track, the risk clause is just "on track" with no numbers or explanation. Only explain (with the numbers) when the call is "at risk" or "off track", and say what changed if it moved off the previous entry's call. Unpointed tickets: say so and ask Casey for an estimate. If no due date, say so and skip the projection.
6. Draft the entry in the format below. Show it to Casey with the RAG suggestion, and wait for approval or edits. Do not write to Jira before approval, since the field is visible to stakeholders.
7. On approval, prepend the entry to the existing field value (keep all older entries untouched, entry separated by a newline) via `editJiraIssue` with `fields: {"customfield_10315": "<new entry>\n<old content>"}`. Only change `customfield_10323` if Casey agrees.
8. Re-read the field to verify it saved, then report the result with the epic link.

## Entry format

Match the house style already in the field (one entry per update, newest first, ISO date):

```
YYYY-MM-DD: <what completed, grouped in a sentence or two, ticket keys in parens> || blockers: <none | specifics> || risk: <on track | at risk, <why, with N days of work left vs M working days> | off track, <why> || next: <what is being picked up>
```

Example from this field: `2026-10-14: M1 completed, picked up M2 no blockers`. On-track example: `... || blockers: none || risk: on track || next: ...`.

Keep it to what a stakeholder can read in 10 seconds: outcomes over ticket titles, no ticket-by-ticket lists unless there are only a few. Use today's date. No em-dashes.

## Gotchas

- `Status updates` is a plain string field, so no markdown or ADF. Newlines are fine.
- Jira turns ticket keys into smartlinks, so reading the field returns `<custom data-type="smartlink">` tags around them. When rebuilding the old entries to write back, collapse those tags to the plain key (e.g. `PD-122085`) rather than copying the tags.
- Re-read the field after writing, and again after waiting about 30 seconds. An open Jira tab with the field in edit mode can autosave a stale copy over the write seconds later (check `changelog` for a revert). If that happens, ask Casey to close or reload the tab before retrying.
- Never overwrite the old entries. Always fetch the current value immediately before writing so a manual edit made in the meantime is not clobbered.
- If the newest existing entry already has today's date, replace that entry with the new one instead of stacking a second entry with the same date. Keep everything older.
- If the epic has zero completed children this week, say so honestly in the entry and flag risk, rather than padding.
