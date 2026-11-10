# Phase 2 — Feature Loop (the standard workflow for every change)

## The sequence

```
1. Translate the request into acceptance criteria (see below)
2. Change exactly one thing
3. ./verify.sh            ← trust the exit code, not the output text
4. Self-tests: --selftest all green; new behavior needs new assertions
5. Offscreen render: --render screenshots; check pixels
6. Real-device screenshot: materials, window behavior, animation, focus — only visible here
7. git commit + tag vX.Y.Z + update CHANGELOG
8. Report: what changed / how it was verified / version number / rollback command
```

## Request → acceptance criteria

| User says | Acceptance criteria |
|---|---|
| "Too fast / too slow" | Animation duration within X±Y ms, and honors reduce-motion |
| "Too bright" | Background L* ≤ 30; tint blend ≤ 12% |
| "Can't read it" | Text/background contrast ≥ 4.5:1 |
| "The button doesn't respond" | Press scale 0.97 / opacity 0.85, visible within 100 ms |
| "The setting does nothing" | Add an assertion that "change setting → UI changes" |
| "Can't drag it" | Draggable source + drop target + visual feedback while dragging |
| "Looks weird" | **Offer 3–6 candidates** instead of trying one at a time |

## Division of labor between verification methods

| Method | Validates | Cannot validate |
|---|---|---|
| Unit tests `--selftest` | Algorithms, storage round-trips, state machines, settings taking effect | The UI |
| Offscreen render `--render` | Layout, color, spacing, copy, type size | Materials, animation, keyboard, windows, real font rasterization |
| Real-device screenshot | Materials, blur, shadows, window behavior, icon cache | Interaction timing |
| Manual use (the user) | Dragging, hover, animation feel, IME compatibility | — |

**Iron rule: anything "visual" must be verified on a real window.** Offscreen rendering lies to you
systematically.

## Debugging discipline

1. **Change one variable at a time**, verify immediately
2. **Disprove before you act**: is this an environment/system/cache problem? (Real case: the window
   wouldn't drag — the machine was wedged)
3. **Don't debug by reverting**: a rollback is an outcome, not a debugging tool
4. **When it "changed nothing", add logging** — and first confirm the new binary is actually running
   (stamp the build time or version)
5. **Silent failures are the most dangerous**: assert explicitly in build, test, and packaging

## The right way to do visual changes

- For aesthetic judgments (colors, icons, materials), **present multiple candidates at once**
  (6–10) and let the user pick, instead of shipping one version and asking
- Render candidates on the **same size, grid, and background**, varying only one dimension
  (shape *or* color)
- Alongside aesthetics, give an engineering verdict: "is this still legible at 16px / 32px?"

## Version and reporting format

End every reply with:

```
Version: vX.Y.Z (committed + tagged / unchanged)
Rollback: git checkout vX.Y.(Z-1) && ./build.sh
```

A three-part change report works best:
1. **What changed** (bulleted, with before/after)
2. **Why this way** (root cause, not symptom)
3. **How it was verified** (test count, screenshots, real-device check)

## When to consider a rewrite

Consider rewriting (rather than patching) if two or more of these hold:

- The stack conflicts with the distribution path (e.g. shipping an LGPL framework on the App Store)
- State management has become a god object; one feature requires touching three places
- There is no visual token system, so every tweak needs global find-and-replace
- Test coverage is under 20% and the core algorithm isn't testable

Otherwise: **refactor locally, don't rewrite globally.**
