# fix-ci · lint handler

Handles failing lint / formatter checks. Invoked by [[SKILL]] after a failure has been classified as lint.

## Inputs

- The failing job log (already fetched by SKILL.md via `gh run view --log-failed`).
- The repo root (working directory).

## Steps

1. **Identify the tool** from the log signature: eslint, prettier, biome, ruff, gofmt. If multiple tools fail, treat each in order.

2. **Look up the repo's autofix command.** First check the target repo's `CLAUDE.md` for the documented lint command. If not present, fall back to `package.json` scripts in this order: `lint:fix`, `format`, `lint -- --fix`. For Go: `gofmt -w .`. For Ruff: `ruff check --fix`.

3. **Run the autofix in place.** Do not pipe through any wrapper. Capture exit code and stderr.

4. **Re-run lint without `--fix`** (or equivalent) to verify zero remaining errors. If clean, return the list of files changed (via `git diff --name-only`).

5. **If errors remain after autofix:** open each flagged file and make the targeted edit indicated by the log. Re-run lint to verify. Stop after one manual pass — do not iterate.

6. **Return** to SKILL.md:
   - On success: `{ ok: true, files: [...] }`
   - On residual errors: `{ ok: false, remaining: <count>, log: <tail of lint output> }`

## Constraints

- Never disable rules. No `eslint-disable`, no `// prettier-ignore`, no `# noqa` unless an adjacent matching suppression already exists in the same file.
- Never edit lockfiles, `eslint.config.*`, `tsconfig.json`, `.prettierrc*`, or workflow files. If the lint failure points at one of these, return `{ ok: false, reason: "protected path" }`.
- Before editing the next file, check the cumulative file count for this invocation (`git diff --name-only | wc -l`) against the 20-file cap defined in SKILL.md. If adding this file would exceed 20, stop and return `{ ok: false, reason: "exceeded file cap" }`.
