# Plan Mode

- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

# Code Style

- Write code that follows the Command-Query Separation design pattern

## Command-Query Separation (CQS)

A principle that states every method should either:

1. Command: Change state but return nothing (void)

- Performs an action/side effect
- Example: user.updateEmail(newEmail)

2. Query: Return data but not change state

- Pure observation, no side effects
- Example: user.getEmail()

_Note_ A Command can call a Query but a Query can not call a command\*

# Workflow

- Be sure to typecheck when your done making a series of code changes
- Prefer running single tests, and not the whole test suite, for performance
