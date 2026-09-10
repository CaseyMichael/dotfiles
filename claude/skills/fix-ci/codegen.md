# fix-ci · codegen handler

Handles failing "verify codegen" checks (generated files out of sync with source, e.g. doc indexes, GraphQL codegen, DB codegen). Invoked by [[SKILL]] after a failure has been classified as codegen.

## Inputs

- The failing job log (already fetched by SKILL.md via `gh run view --log-failed`).
- The repo root (working directory).

## Steps

1. **Confirm the signature.** The log shows a `git diff` of unstaged changes plus `Unstaged changes detected. Locally run 'pnpm codegen' and commit changed files` (or equivalent). This confirms generated output is stale, not a real logic bug.

2. **Run codegen from the repo root** (not a filtered package): `pnpm codegen`.

3. **Check for changes:** `git status --porcelain`. If empty, codegen is already in sync locally — the CI failure doesn't reproduce here. Return `{ ok: true, files: [] }` and let SKILL.md report it as a no-op.

4. **Re-run `pnpm codegen` once more** and confirm `git status --porcelain` is unchanged between the two runs (idempotency check). If the second run produces further diffs, return `{ ok: false, reason: "codegen not idempotent" }`.

5. **Return:**
   - On success with changes: `{ ok: true, files: [...] }` (from `git diff --name-only` + untracked files under the generated paths).
   - On no changes needed: `{ ok: true, files: [] }`.
   - On non-idempotent output: `{ ok: false, reason: "codegen not idempotent" }`.

## Constraints

- Only run the root `pnpm codegen` command — never a package-filtered variant, since generated indexes (e.g. doc indexes) span the whole repo.
- If codegen output touches a protected path (same list as SKILL.md safety rules: `.github/workflows/`, `package-lock.json`, `pnpm-lock.yaml`, `go.sum`, `tsconfig.json`, `Dockerfile`, `infra/`, `cdk8s/`), return `{ ok: false, reason: "protected path" }` — do not commit those changes even though codegen produced them.
- Before finalizing, check the cumulative file count for this invocation (`git diff --name-only | wc -l`) against the 20-file cap defined in SKILL.md. If codegen's output alone exceeds the cap, return `{ ok: false, reason: "exceeded file cap" }`.
- No new dependencies. If `pnpm codegen` itself fails (not just produces a diff), return `{ ok: false, reason: <error output> }` rather than papering over it.
