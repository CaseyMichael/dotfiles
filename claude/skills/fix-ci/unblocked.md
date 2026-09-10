# fix-ci · unblocked handler

Handles unresolved review comments left by `unblocked[bot]`. Invoked by [[SKILL]] before the CI handlers.

## Inputs

- Owner, repo, and PR number (already known by SKILL.md).
- Repo root (working directory).

## Fetch unresolved threads

Use GraphQL — REST does not expose thread resolution state. Bot logins in GraphQL are the raw app slug (`unblocked`), not `unblocked[bot]`.

```
gh api graphql -f query='
  query($owner:String!,$repo:String!,$pr:Int!){
    repository(owner:$owner,name:$repo){
      pullRequest(number:$pr){
        reviewThreads(first:100){
          nodes{
            id
            isResolved
            comments(first:50){
              nodes{
                databaseId
                author{login}
                body
                path
                line
                originalLine
                diffHunk
              }
            }
          }
        }
      }
    }
  }' -f owner=<owner> -f repo=<repo> -F pr=<pr-number>
```

Keep threads where `isResolved == false` AND at least one comment has `author.login == "unblocked"`. Within each such thread, address the earliest unblocked comment (the one that opened the thread). Cache the thread `id` for later resolution.

If zero threads survive the filter, return `{ ok: true, files: [] }` and skip the handler.

## Steps per thread

1. **Prefer the suggestion block.** If the comment body contains a fenced ` ```suggestion ... ``` ` block, apply it verbatim: replace `line` (or `start_line..line` if present) on `path` with the suggestion body. This is the deterministic path — take it when available.

2. **Otherwise reason from the body.** Read the referenced file, understand the flagged concern, and make the smallest edit that resolves it. Do not expand scope beyond what the comment names.

3. **Verify the edit compiles / parses.** For TS/JS, a quick `tsc --noEmit` on the touched file is enough; for other languages, syntax-check via the language's parser. Full test runs are the tests handler's job — do not run them here.

4. **Track outcomes.** For each thread, record `{ threadId, applied: bool, reason?: string }`. `applied: false` reasons include: `no suggestion and body is not actionable`, `path outside repo`, `protected path`, `file cap reached`.

## Constraints

- Only address comments authored by `unblocked` (GraphQL login). Never touch human review comments here — those are for the reviewer to accept.
- Protected paths (same list as SKILL.md safety rules): skip and record `reason: "protected path"`. Do not stop the run; other threads may still be actionable.
- Respect the 20-file cumulative cap. Before applying each thread, check `git diff --name-only | wc -l`; if adding this file would exceed 20, stop applying further threads and return `{ ok: true, files: [...applied], remaining: <count> }`. This is a soft cap for this handler — the run continues into lint/types/tests.
- No new dependencies, no `as any`, no rule suppressions, same as SKILL.md.

## Return

- On any applied edits: `{ ok: true, files: [...], threads: [...outcomes] }`.
- On zero unresolved threads matching: `{ ok: true, files: [], threads: [] }`.
- On unrecoverable error (e.g. GraphQL failure): `{ ok: false, reason: <msg> }`.

## Post-push: resolve threads

Called by SKILL.md **after** the push succeeds, once per thread whose fix landed in a commit (`applied: true`):

```
gh api graphql -f query='
  mutation($id:ID!){
    resolveReviewThread(input:{threadId:$id}){
      thread{ isResolved }
    }
  }' -f id=<threadId>
```

If resolution fails for a thread, log it in the final report but do not fail the run — the code fix already landed.
