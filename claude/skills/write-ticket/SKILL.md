---
name: write-jira-ticket
description: Use when user asks to write, create, or file a Jira ticket after discussing a problem or solution in conversation. Triggered by phrases like "write up a ticket", "create a jira", "file this", "write the ticket", "open a ticket for this", or "let's track this". Use this skill any time the user wants to formalize a conversation into a trackable Jira issue, even if they don't use these exact phrases.
---

# Write Jira Ticket from Conversation

## Overview

Synthesize the current conversation into a brief Jira ticket. The conversation IS the source of truth — extract the problem and context from it rather than asking the user to repeat themselves.

**Philosophy:** These tickets are written by a team lead for engineers on the team. Focus on the *problem* and (for bugs) *file pointers to where the issue likely lives*. Do not prescribe the solution — let the assignee figure out what to do. Keep tickets short.

## Process

### 1. Synthesize from Conversation

Before creating anything, extract from the conversation:

- **Problem**: What is broken, missing, or needs to change? What is the impact?
- **File pointers (bugs only)**: Specific files/functions/line numbers where the issue likely lives, if discussed or discoverable from context
- **Type**: Bug, Story, Task, Spike? (infer from the nature of the discussion)

Do NOT extract or invent acceptance criteria, implementation steps, or "what done looks like" — that's the assignee's job.

If key information is genuinely missing, ask one focused question before proceeding — don't ask about things you can infer.

### 2. Map to Jira Fields

| Conversation element | Jira field                              |
| -------------------- | --------------------------------------- |
| Problem statement    | Summary + Description (Problem section) |
| File pointers (bugs) | Description (Pointers section)          |
| Issue type           | `issue_type`                            |
| Urgency/impact       | `priority` (Highest/High/Medium/Low)    |

**Description format (keep it brief — usually 2-6 lines total):**

```
## Problem
<what is wrong and why it matters — 1-3 sentences>

## Pointers
<file:line references where the issue likely lives — bugs only, omit section if not a bug or if unknown>
```

Omit either section if not applicable. Do not pad with restated context, solution proposals, or acceptance criteria.

### 3. Create the Ticket

Use `mcp__jira__jira_create_issue`. Default to project `PD` unless another project was discussed.

**Required fields at minimum:**

- `project_key` (default: `PD`)
- `summary`
- `issue_type` (Story / Bug / Task / Spike)
- `description` (formatted as above)

**Required `additional_fields` for all PD tickets:**

- `customfield_10324` (Product Domain) — always set to `[{"id": "10650"}]` ("Integrations")
- `customfield_10001` (Team) — **cannot be set on creation**, must be set via a follow-up `editJiraIssue` call after the ticket is created
- `customfield_10008` (Epic Link) — **every ticket must be linked to an epic.** If the epic is obvious from the conversation, use it. If not, ask the user which epic before creating the ticket. Do not create unparented tickets.

**Two-step pattern for setting Team:**

Step 1 — create with Product Domain only:
```json
{
  "customfield_10324": [{"id": "10650"}]
}
```

Step 2 — immediately after creation, call `mcp__atlassian__editJiraIssue` with the bare string ID:
```json
{
  "customfield_10001": "488c92e2-c608-481e-b2a0-95ddcd0f9024"
}
```

> The Team field rejects `{"id": "..."}` format on creation but accepts a plain string ID on edit. Always do both steps.

**Optional fields to set when clear from context:**

- `priority` — set if urgency/impact is evident (Highest / High / Medium / Low / Lowest)
- `assignee: {"displayName": "Name"}` — if assignee was mentioned

For sprint assignment, board IDs, and other custom field formats, consult the `jira-workflows` skill.

### 4. Report Back

After creating, report:

- Ticket key + URL
- One-line summary of what was filed

## Quick Reference

| Situation             | Action                                                                        |
| --------------------- | ----------------------------------------------------------------------------- |
| No project mentioned  | Default to `PD`                                                               |
| No issue type clear   | Default to `Story`                                                            |
| Assignee mentioned    | `assignee: {"displayName": "..."}`                                            |
| Priority is clear     | Set `priority` (Highest / High / Medium / Low)                                |
| Epic unclear          | Ask the user which epic before creating — never file without one              |
| Always (PD project)   | Set `customfield_10008: "EPIC-KEY"` + `customfield_10324: [{"id":"10650"}]` on create, then edit with `customfield_10001: "488c92e2-c608-481e-b2a0-95ddcd0f9024"` |

## Common Mistakes

- **Asking the user to repeat the problem** — it's already in the conversation, read it
- **Writing acceptance criteria or solution steps** — don't. The assignee decides what to do; the ticket states the problem.
- **Padding the description** — keep it brief. If you're writing more than ~6 lines, you're over-explaining.
- **Inventing file pointers** — only include `Pointers` for bugs when specific files/lines were actually discussed or are clearly identifiable from the conversation.
- **Wrong project** — default to `PD` when not specified
- **Wrong MCP tool** — use `mcp__atlassian__createJiraIssue` with `cloudId: "7ba5ee6a-370d-4a80-a828-07b78ac8f75e"`
- **Missing required fields** — always include `customfield_10324` (Product Domain) and `customfield_10008` (Epic Link) in `additional_fields`
- **Filing without an epic** — every ticket must be parented to an epic. If unclear, ask the user before creating.
- **Team field format** — `customfield_10001` must be set via a separate `editJiraIssue` call after creation using a plain string ID: `"488c92e2-c608-481e-b2a0-95ddcd0f9024"`. The `{"id": "..."}` object format is rejected on creation.
