# Testing

## Writing tests

- Keep all tests simple and minimal
- Prefer writing parameterized tests over multiple describe / it blocks
- Repeated test setup code should be abstracted to a shared function
- Do not make any assertions on log statements
- Do not write tests that do not add value that simple TS typechecking provides
