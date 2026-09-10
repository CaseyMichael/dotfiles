---
name: write-pr-description
description: Use whenever filling out a PR description in the lattice repo — creating a PR with `gh pr create`, the GitHub MCP, or drafting the body/title before either. Triggers on "open a PR", "write the PR description", "fill out the PR body", "create a draft PR", or any moment about to write into `.github/agent_pull_request_template.md`. Also use when reviewing/tightening an existing PR description someone drafted, or when asked what a good Lattice PR description looks like. Covers both the interactive (human + Claude) style and the CI/agent-authored style, and which one applies.
---

# Writing a Lattice PR description

Reviewers read the diff for the "what." The description exists for the "why" and to compress "what changed" into something scannable. Everything here optimizes for a reviewer skimming this in under 30 seconds.

Gold-standard examples (same author, same epic, read all five to see the pattern hold across a stack): PRs #129998, #129604, #130415, #130805, #130954.

## Which mode applies

Run `bin/is-ci` first.

- **CI / autonomous, no human in the loop**: use the full `.github/agent_pull_request_template.md` verbatim, including the "Before/After deployment" split under Validation and the "Claude Code prompt and workflow details" footer. This is a hard requirement — see the repo's `CLAUDE.md`, not optional here.
- **Interactive, Casey (or any human) driving the session**: use the leaner structure below. It's the same template with the deployment-checklist scaffolding and agent footer dropped, because a human is right there to answer questions and there's no autonomous-run metadata to disclose.

If unsure which mode you're in, default to the leaner interactive structure — that's the one every gold-standard example uses.

## Structure

```
## <TICKET-ID>
[optional: more context [here](notion-link) — only when a design doc exists]

## Why this change was made
[1-3 sentences]

## What changed
- [bullet]
- [bullet]

## Validation
```

**Title**: `<TICKET-ID> <imperative, specific summary>` — e.g. "PD-119968 Add glean redirect urls gql", not "Update GQL schema" or "Fixes".

**Ticket header**: write the bare ticket ID (`## PD-119964`), nothing fancier. A bot rewrites it into a link automatically — that's why the template comment says "a link... will be generated automatically." Don't hand-roll the link; let the automation do it (you'll see it land as a footnote-style reference at the bottom of the rendered body). If there's no ticket, write `## NOTICKET`, don't leave the placeholder.

**Why this change was made** — this is the section reviewers actually read, and the one most PRs get wrong by leaving thin or skipping. Two moves, in order:
1. State the external constraint or business reason driving the work ("Glean requires each customer to have a separate slug which means each company has a different redirect URL").
2. State the technical decision this PR makes in response, including what it avoids ("so to avoid leaking different companies data, we want to store each company's redirect url and then sync the url list to ory asynchronously").

If this PR is one slice of a bigger stack, anchor it with a short phrase ("As part of the Glean support work...", "To support glean we need...") and then explain only *this PR's* slice — don't re-explain the whole epic in every PR of the stack. #130954 in the gold set left this section blank; that's the one weak example in the set, not something to copy. If you don't know the why and would be guessing, stop and ask rather than filling in something you made up — this matches the standing project rule.

**What changed** — bullets, not prose. Each bullet names one concrete artifact and what happened to it, verb-first: "Added mcp-worker weaver module and queue", "Emit McpMarketplaceUpdated event when updating/deleting a redirectUrl". No bullet should need a sub-clause explaining how it works internally — that's what the diff is for. If you can't compress a change into a short verb-first phrase, it's probably two changes.

**Validation** — leave this section empty. Write the `## Validation` header and stop there; Casey fills it in by hand every time (usually a screenshot or screen recording he captures himself). Never fill this in on his behalf, and never write anything in it about automated tests, CI status, or "steps taken" — that's not what this section is for here, regardless of what the raw template text suggests.

## Don't

- Don't leave `JIRA CARD NUMBER` unfilled, or leave Why blank because you're not sure — ask instead.
- Don't add the Before/After-deployment subheadings or the agent footer in interactive mode; that scaffolding exists for unattended runs, and every human-driven gold example omits it.
- Don't write "What changed" as narrative sentences — if you're writing "This PR also..." you've drifted into prose.
- Don't restate the reviewer's own point or over-explain background a Lattice engineer already has — same bar as PR comments.
- Don't write anything under `## Validation` — see above.
