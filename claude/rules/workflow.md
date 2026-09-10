# Workflow

- Always write tests before making any changes
- Always lint each of the files you've touched and fix any errors or warnings
- Always build and typecheck the individual files when you've made code changes
- Always run tests related to the code changes before you are done
- Prefer running single tests, and not the whole test suite, for performance
- When you need to stack branches use the tool git-machete
- To scope a jest run through a pnpm script, pass the path pattern as a bare positional argument, never as a flag: `pnpm -F weaver test -- 'path/to/pattern'`, not `pnpm -F weaver test -- --testPathPatterns 'path/to/pattern'`. `pnpm run` inserts a literal `--` ahead of forwarded arguments and jest treats everything after `--` as positional path patterns, so every flag silently becomes a filename regex. `--help` searches for a file named `--help`; the wrapper's own `--selectProjects` lands past the `--` too, so project scoping dies and a run that looks scoped drags in unrelated suites.
- When a test run genuinely needs flags (`-u`/`--updateSnapshot`, `--selectProjects`, `-t`, `--watch`), bypass the pnpm script and call jest directly from the app directory: `cd apps/weaver && pnpm exec jest --selectProjects=db-integration -w 1 -u --testPathPatterns 'pattern'`. Pass one project at a time; a comma-joined `--selectProjects` list finds no projects there.
