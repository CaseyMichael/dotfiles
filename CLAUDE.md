# Plan Mode

- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

# Code Style

- Write code that adheres to the following principles

## Tell, Don't Ask

- Tell objects what to do, don't ask for their state and make decisions
- order.complete() not if (order.getStatus() === 'pending') order.setStatus('complete')

## Composition Over Inheritance

- Favor "has-a" relationships over "is-a"
- More flexible, avoids deep inheritance hierarchies

## Fail Fast

- Validate inputs immediately at boundaries
- Throw errors early rather than propagating invalid state

## DRY (Don't Repeat Yourself)

- Avoid duplicate logic
- Extract common patterns into reusable functions

## YAGNI (You Aren't Gonna Need It)

- Don't add functionality until it's necessary
- Avoid over-engineering

## Law of Demeter (Principle of Least Knowledge)

- Only talk to immediate friends
- Avoid chaining: object.getX().getY().doZ() → pass what you need directly

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
