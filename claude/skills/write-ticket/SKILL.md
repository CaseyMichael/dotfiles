---
name: write-jira-ticket
description: Use when user asks to write, create, or file a Jira ticket after discussing a problem or solution in conversation. Triggered by phrases like "write up a ticket", "create a jira", "file this", "write the ticket", "open a ticket for this", or "let's track this". Use this skill any time the user wants to formalize a conversation into a trackable Jira issue, even if they don't use these exact phrases.
---

# Write Jira Ticket from Conversation

## Overview

Synthesize the current conversation into a well-structured Jira ticket. The conversation IS the source of truth — extract the problem, solution, and context from it rather than asking the user to repeat themselves.

## Process

### 1. Synthesize from Conversation

Before creating anything, extract from the conversation:

- **Problem**: What is broken, missing, or needs to change? What is the impact?
- **Context**: Any technical details, constraints, affected areas, or linked work
- **Acceptance criteria**: What does "done" look like? (derive from the solution discussion)
- **Type**: Bug, Story, Task, Spike? (infer from the nature of the discussion)

If key information is genuinely missing (e.g. no solution was discussed), ask one focused question before proceeding — don't ask about things you can infer.

### 2. Map to Jira Fields

| Conversation element | Jira field                              |
| -------------------- | --------------------------------------- |
| Problem statement    | Summary + Description (Problem section) |
| Acceptance criteria  | Description (AC section)                |
| Technical context    | Description (Notes section)             |
| Issue type           | `issue_type`                            |
| Urgency/impact       | `priority` (Highest/High/Medium/Low)    |

**Description format:**

```
## Problem
<what is wrong and why it matters>

## Acceptance Criteria
- [ ] <criterion 1>
- [ ] <criterion 2>

## Notes
<any technical context, links, constraints>
```

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
- `customfield_10008: "EPIC-KEY"` — to link an epic/parent if one was discussed

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
| Epic mentioned        | `additional_fields: {"customfield_10008": "EPIC-KEY"}`                        |
| Always (PD project)   | Create with `customfield_10324: [{"id":"10650"}]`, then edit with `customfield_10001: "488c92e2-c608-481e-b2a0-95ddcd0f9024"` |

## Common Mistakes

- **Asking the user to repeat the problem** — it's already in the conversation, read it
- **Generic acceptance criteria** — derive specific, testable criteria from the solution discussion
- **Skipping the description format** — always use the structured Problem/AC/Notes format
- **Wrong project** — default to `PD` when not specified
- **Wrong MCP tool** — use `mcp__atlassian__createJiraIssue` with `cloudId: "7ba5ee6a-370d-4a80-a828-07b78ac8f75e"`
- **Missing required fields** — always include `customfield_10324` (Product Domain) in `additional_fields`
- **Team field format** — `customfield_10001` must be set via a separate `editJiraIssue` call after creation using a plain string ID: `"488c92e2-c608-481e-b2a0-95ddcd0f9024"`. The `{"id": "..."}` object format is rejected on creation.
