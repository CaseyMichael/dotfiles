---
name: write-doc
description: Write documentation after an investigation or research session using the Diataxis framework. Use when user asks to document findings, write up an investigation, create docs, or turn conversation results into lasting documentation.
---

You are writing documentation as the **final step after an investigation**. The conversation contains your findings — your job is to transform those findings into clear, lasting documentation using the Diataxis framework.

The subject of this documentation is: ${ARGUMENTS}

---

## Step 1: Pick a Diataxis type

Diataxis organizes docs into four types based on two questions:

**Is this content about action or cognition?**
- Action → practical steps, doing
- Cognition → theoretical knowledge, understanding

**Does the reader need to acquire or apply?**
- Acquisition → learning something new
- Application → using existing knowledge to get work done

|               | Action         | Cognition     |
|---------------|----------------|---------------|
| **Acquisition** | Tutorial     | Explanation   |
| **Application** | How-To Guide | Reference     |

If unsure, ask what question the reader is bringing:
- "Can you teach me to...?" → **Tutorial**
- "How do I...?" → **How-To Guide**
- "What is...?" → **Reference**
- "Why does this work this way?" → **Explanation**

If the findings naturally span more than one type, write separate documents — one per type. Mixed documents serve no reader well.

---

## Step 2: Write the document

### Tutorial
*Reader: a newcomer building a skill for the first time.*

The goal is to create an **experience**, not an explanation. Learning flows naturally from doing.

- Open with: what the reader will accomplish, and what they need to start
- Use imperatives and first-person plural: "Do x. Now do y. Notice that..."
- Every step must produce a **visible, concrete result**
- Minimize explanation — link out rather than digress
- Close by summarizing what was accomplished and pointing toward next steps

### How-To Guide
*Reader: a practitioner who knows what they want and needs direction.*

Stay strictly goal-oriented. Assume competence.

- Title is specific and action-oriented: "How to configure X" — not "X configuration"
- Focus on the **human goal**, not the mechanics of a tool
- Steps follow the order a practitioner would actually work in
- No teaching — link to Reference or Explanation for background
- State any prerequisites upfront

### Reference
*Reader: someone consulting mid-task who needs authoritative, accurate facts.*

Describe and only describe. Neutral tone, no narrative, no opinion.

- Mirror the structure of the thing being documented (API by endpoint, CLI by command, etc.)
- Consistent formatting throughout — readers scan, not read
- Examples that **illustrate** usage without explaining it
- Enumerate all options, parameters, limitations, and error states

### Explanation
*Reader: someone who wants to understand, not act.*

This is the only Diataxis type where opinion and perspective belong.

- Start broad: frame the topic and why it matters
- Provide context: design decisions, historical reasons, alternatives considered
- Make connections across related concepts and systems
- Use "why" questions to guide and bound the scope
- Write in prose — discursive, reflective, not procedural

---

## Step 3: Pull from the investigation

Use what was actually discovered in this conversation:
- Specific behaviors, outputs, and outcomes observed
- Code, commands, or configurations explored
- Edge cases, gotchas, or surprises
- Decisions made and reasoning behind them (especially useful in Explanation)

Do not invent content that wasn't investigated. A shorter, accurate doc beats a padded, speculative one.

---

## Step 4: Save the file

Save as `.md` to `/Users/casey/Developer/claude-memory/` by default, unless the user specifies a different location or the document clearly belongs inside a specific project (e.g., a CLAUDE.md or in-repo reference doc). If the destination is genuinely ambiguous, propose a path before saving.
