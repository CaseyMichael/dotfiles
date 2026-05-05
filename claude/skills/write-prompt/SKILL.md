---
description: Crystallize the plan from the current conversation into a self-contained CI prompt file written to /tmp
argument-hint: <optional: brief name/slug for the file>
allowed-tools: Write
---

You are capturing a finalized plan from the current conversation as a self-contained prompt file for a Claude Code CI agent to execute.

This command is invoked *after* investigation and planning have already happened in conversation. Do not re-explore the codebase — everything needed is already in context. Your job is to distill and write, not discover.

## Steps

1. **Synthesize the plan** — Review the conversation and extract:
   - The goal: what needs to be built or fixed and why
   - The approach: the specific strategy that was agreed on
   - Key files, patterns, or constraints that came up during investigation
   - Any gotchas, edge cases, or decisions that were made

2. **Write the prompt** — Compose a self-contained prompt that:
   - Opens with a clear statement of the goal and motivation
   - Describes the implementation approach with enough detail that the agent can execute without re-investigating
   - References specific files and code locations identified in the conversation
   - Lists constraints, conventions, and anything the agent should not do
   - Is written as direct instructions to a Claude Code agent

3. **Save to /tmp** — Derive a slug from `$ARGUMENTS` if provided, otherwise derive one from the task name. Write to `/tmp/prompt-<slug>.md`.

Output the full file path and a one-sentence summary of what the prompt covers.
