---
name: fix-ci
description: Use when a PR has failing CI checks or unresolved unblocked[bot] review comments and the user wants them auto-resolved. Triggered by phrases like "fix the CI on this PR", "fix the failing checks", "resolve unblocked comments", "address unblocked feedback", "/fix-ci", or when the user pastes a PR URL and asks why CI is red and to fix it. Operates on the PR associated with the current git branch.
---

# fix-ci

One-shot resolver for two blockers on the current branch's PR: failing CI checks and unresolved review comments from `unblocked[bot]`. Gathers both, routes each to the matching handler, commits per category, pushes once, and exits.

## Pre-flight

Stop with a one-line reason if any of the following:

- `gh auth status` fails.
- Current branch is `main` or `master`.
- `gh pr view --json number,url,headRefName` fails (no PR for this branch).
- Working tree is dirty (`git status --porcelain` returns non-empty). Reason: skill commits would conflate user edits with handler fixes.
- Branch is out of date with its remote (`git status -sb` shows `behind`).

**Soft check (ask, do not stop):** If the working directory is a repo's main checkout rather than a worktree, warn the user that working outside a worktree is discouraged per the workspace's CLAUDE.md rule, and ask before proceeding. Other workspaces may not have this rule — use judgment.

## Triage flow

1. **Fetch failing checks.** `gh pr checks <pr-number> --json name,state,link,workflow`. Keep entries where `state == "FAILURE"`.

2. **Fetch unresolved unblocked[bot] threads.** Query the PR's review threads via GraphQL and keep threads where `isResolved == false` AND any comment in the thread has `author.login == "unblocked"`. See [[unblocked]] for the query.

3. **Exit early if both empty.** If there are no failing checks and no unresolved unblocked threads, exit: "CI is green and no unblocked comments, nothing to do."

4. **Pull job logs.** For each failing check, run `gh run view <run-id> --log-failed`. If that returns empty, fall back to `gh run view <run-id> --log`. Cache per check. Extract the run ID from the `link` field returned by `gh pr checks` — it is the trailing path segment of a URL like `https://github.com/<owner>/<repo>/actions/runs/<RUN_ID>`. Alternatively: `gh run list --branch $(git branch --show-current) --json status,conclusion,databaseId,name --jq '.[] | select(.conclusion=="failure")'`.

5. **Classify** each failure into `infra`, `lint`, `types`, `tests`, `codegen`, or `unknown` by matching the log against these signatures:
   - **infra:** `The self-hosted runner lost communication`, `containerd-stargz-grpc.sock`, `docker: failed to prepare`, `dial unix`, `snapshot ... connection error`, `##[error]No test report files were found` when paired with a runner/docker error, workflow "cancelled" without any test output. These are transient CI-infrastructure failures — no code change fixes them.
   - **lint:** `eslint`, `prettier`, `biome`, `ruff`, `gofmt`, "code style", `Error:` lines from lint runners
   - **types:** `error TS\d+`, `tsc`, `cannot use ... as ...` (Go), `mypy`, `pyright`
   - **tests:** `FAIL `, `--- FAIL:`, `FAILED `, `expected ... received`, assertion failures
   - **codegen:** `Unstaged changes detected`, `run 'pnpm codegen'`, a job/step named "Verify codegen", or a `git diff` block showing generated files (schema, doc indexes, DB codegen) changed with no lint/type/test signature alongside it
   - **unknown:** none of the above matched

6. **Handle infra failures first.** For each `infra`-classified check, run `gh run rerun <run-id> --failed` once per unique `<run-id>` (deduplicate — one rerun retries every failed job in that workflow run). Aggregate check names that belong to the same run under one rerun. Record the run IDs rerun in the report. Do NOT wait for the rerun to complete — this is fire-and-forget.

7. **Route the rest in order: unblocked → lint → types → tests → codegen.** Unblocked first because applied suggestions may produce lint/format churn that the lint handler then cleans up. Codegen last because earlier handlers may add/rename files that generated indexes need to reflect. For each item, follow the corresponding handler: [[unblocked]], [[lint]], [[types]], [[tests]], [[codegen]]. Skip `unknown` failures and report them at the end.

8. **Handle handler errors.** If any handler returns `{ ok: false, reason: ... }`, STOP. Do not push. Do not commit. Leave uncommitted edits in the working tree for the user to inspect. Report. Exception: if the returned `reason` is `"protected path"`, prompt the user with the specific path and the failure context, and ask whether to proceed manually or abort. Do not auto-edit protected paths under any circumstance.

## Commit and push

Commits and the push happen ONLY after all handlers have completed without errors. If any handler returned `{ ok: false, ... }`, skip ALL commits — including handlers that succeeded earlier in the run. Their edits remain uncommitted in the working tree.

- One commit per handler that produced changes, in handler order:
  - unblocked → `fix: address unblocked bot feedback`
  - lint → `style: fix lint`
  - types → `fix: resolve type errors`
  - tests → `fix: resolve failing tests`
  - codegen → `update generated code`
- Skip a commit if the handler reported `{ ok: true, files: [] }`.
- After all commits, single `git push`. Never force-push. If push is rejected, stop and report.
- **Thread resolution:** After the push succeeds, resolve each unblocked thread whose comment was actually addressed by a committed edit. See [[unblocked]] for the mutation. Never resolve a thread whose fix did not land.
- No PR comment in v1.

## Safety rules (apply across all handlers)

- No force-push. Plain `git push` only.
- No work on `main` / `master`. Pre-flight enforces; never bypass.
- Protected paths never edited unless the log explicitly points there: `.github/workflows/`, `package-lock.json`, `pnpm-lock.yaml`, `go.sum`, `tsconfig.json`, `Dockerfile`, `infra/`, `cdk8s/`. On a protected-path failure, stop and ask.
- No new dependencies.
- No test deletion, no `.skip`.
- No `as any`, `@ts-ignore`, `eslint-disable` unless an adjacent matching suppression already exists.
- Hard cap across all handlers in one invocation: 20 files changed. If exceeded, stop without committing or pushing. Leave all uncommitted edits in the working tree for the user to inspect.

## Report (always print at end)

- Each failing check: classification (infra / lint / types / tests / codegen / unknown).
- Unblocked threads found: count, and per-thread outcome (`applied`, `skipped: <why>`).
- Each handler outcome: `fixed (N files)`, `skipped (no changes)`, or `errored: <reason>`.
- Infra reruns triggered: list of `<run-id>` values passed to `gh run rerun --failed`.
- Commit SHAs created.
- Push outcome.
- Threads resolved (count).
- Reminder: CI will re-run; if new failures appear, re-invoke fix-ci.
