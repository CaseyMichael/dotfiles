# fix-ci · types handler

Handles failing typecheck checks (TypeScript `tsc`, Go build errors, mypy/pyright). Invoked by [[SKILL]] after a failure has been classified as types.

## Inputs

- Failing job log.
- Repo root.

## Steps

1. **Parse errors** from the log. Extract `(file_path, line, message)` tuples. For TypeScript, the canonical line is `path/to/file.ts(LINE,COL): error TS\d+: <message>`. For Go: `path/to/file.go:LINE:COL: <message>`.

2. **For each error:**
   - Read the file. Read enough surrounding context to understand the type's role.
   - Make a targeted edit that fixes the type at the cause, not the symptom.
   - Do NOT introduce `as any`, `as unknown`, `@ts-ignore`, `@ts-expect-error`, `// @ts-nocheck`, or Go's `interface{}` widening. These count as test-shaped shortcuts.

3. **Run the repo's local typecheck.** Look up the command from `<repo>/CLAUDE.md`. Fall back to `npx tsc --noEmit` for TS, `go build ./...` for Go.

4. **Verify zero errors.** If errors remain, return `{ ok: false, remaining_errors: [...] }`. Do not iterate beyond one pass through the original error list — the next CI run will surface anything new.

5. **Return:**
   - On success: `{ ok: true, files: [...] }`
   - On residual: `{ ok: false, remaining_errors: [...] }`

## Constraints

- Edits stay inside the repo root. Never touch `tsconfig.json`, `go.mod`, or `package.json` to "fix" a type error.
- If a fix would require adding a dependency, stop and return `{ ok: false, reason: "needs new dependency" }`.
- Before editing the next file, check the cumulative file count for this invocation (`git diff --name-only | wc -l`) against the 20-file cap defined in SKILL.md. If adding this file would exceed 20, stop and return `{ ok: false, reason: "exceeded file cap" }`.
