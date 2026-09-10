# fix-ci · tests handler

Handles failing test checks (jest, vitest, go test, pytest, rspec). Invoked by [[SKILL]] after a failure has been classified as tests.

## Inputs

- Failing job log.
- Repo root.

## Steps

1. **Parse failures** from the log. Extract `(test_name, file_path, assertion_message)` per failure. Test runners differ in format — match the common patterns:
   - jest/vitest: `FAIL <path> > <suite> > <name>` with assertion below
   - go test: `--- FAIL: TestName (...)` with file:line under it
   - pytest: `FAILED <path>::<test_name> - <message>`

2. **For each failure:**
   - Read the test. Read the code under test.
   - Identify the real cause: is the implementation wrong, or is the test asserting something incorrect?
   - **Default: fix the implementation.** Only fix the test if the assertion itself is provably wrong (do not hard-code values, special-case the inputs the test uses, or otherwise satisfy only the test rather than the requirement).
   - Make the targeted edit.

3. **Re-run only the failing tests locally.** Examples:
   - vitest: `pnpm vitest run <path>` or `pnpm vitest run -t "<name>"`
   - jest: `pnpm jest <path> -t "<name>"`
   - go test: `go test -run TestName ./pkg/...`
   - pytest: `pytest <path>::<test_name>`
   Match the project's package manager from its `CLAUDE.md` or `package.json`.

4. **Regression check:** After fixing, if a previously-passing test in the same file now fails, STOP. Return `{ ok: false, reason: "regression in <test>" }`. This is a human-review situation.

5. **Return:**
   - On success: `{ ok: true, files: [...] }`
   - On residual: `{ ok: false, remaining_failures: [...] }`

## Constraints

- Never add `.skip`, `.only`, `xit`, `xdescribe`, `t.Skip()`, or `@pytest.mark.skip`. A failing test is fixed by fixing code or assertion — not by silencing.
- Never delete a test to make CI green.
- Never introduce new mocks. If a test already mocks `X`, you may extend the mock; do not start mocking something that was previously real.
- If a fix would require adding a dependency, stop with `{ ok: false, reason: "needs new dependency" }`.
- Before editing the next file, check the cumulative file count for this invocation (`git diff --name-only | wc -l`) against the 20-file cap defined in SKILL.md. If adding this file would exceed 20, stop and return `{ ok: false, reason: "exceeded file cap" }`.
