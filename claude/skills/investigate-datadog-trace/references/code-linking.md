# Code-Linking Playbook

Map the failing/slow span to `file:line` pointers in the user's lattice checkout.

## Search target

**`/Users/casey.peters/Developer/lattice` only.** No fallback to other repos. If not found here, the investigation fails the link step and stops.

## Steps

1. **Pre-flight: skip if span is third-party.** If the span's stack/resource clearly comes from framework or vendor code (e.g., `node_modules/`, `site-packages/`, library namespaces with no lattice resource), report "span is in third-party code — no code link" and stop.

2. **Build a search needle.** From the span pick, in priority order:
   - Top non-vendor frame in `error.stack`
   - `resource_name` (often a controller/route/function name)
   - `operation_name`

3. **Grep lattice.** Use ripgrep:

   ```bash
   rg -n --max-count 20 '<needle>' /Users/casey.peters/Developer/lattice
   ```

   For function names, also try the language-appropriate definition pattern (e.g., `def <name>\(`, `function <name>\(`, `<name>\s*=.*=>`).

4. **Report results honestly.**
   - **1 match:** report `file:line` with 2–3 lines of context.
   - **0 matches:** say "No match in lattice for `<needle>`" and stop. Do not fall back to other repos. Do not guess.
   - **Multiple matches:** list all candidates with `file:line`. Ask the user to pick (or proceed only if one obviously matches the span's service/path).

## Anti-patterns

- Searching outside lattice when there's no match (spec is explicit: no fallback).
- Reporting one match when there are many — be honest about ambiguity.
- Linking to vendor code paths inside `lattice/node_modules/` etc.
