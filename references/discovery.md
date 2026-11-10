# Phase 0 — Discovery (PM questionnaire)

Goal: before the first line of code, produce a `PROJECT.md` (10 lines max).
**Ask 3–5 questions at a time**, never 20. Ask in the order below, because earlier answers
invalidate later options.

## Group 1 — Purpose and constraints (must ask; these decide everything)

1. **What does this software do? One sentence.**
   - Follow-up: what pain does it solve? What do you use instead today?
2. **Who is it for?**
   - Just you / friends for testing / strangers / a store release
   - Affects: error tolerance, onboarding, crash handling, privacy compliance
3. **Which platform?**
   - macOS / iOS / both / web / Windows
4. **How will it be distributed?** ← the single most important answer
   - App Store (sandbox, review, signing, GPL/LGPL libraries restricted)
   - Developer-signed direct download (needs an Apple Developer account + notarization)
   - Internal / just for you (ad-hoc signing is plenty)
   - Web (front-end stack)
   - **This answer alone can eliminate the tech stack**: Qt/PySide can't ship on the MAS;
     Electron is heavy; pure SwiftUI is Apple-only

## Group 2 — Features and data

5. **Core features — 3 max.** (Prevents feature creep.)
   - Follow-up: if you could keep only one, which is it?
6. **Where does data live? Does it need to sync across devices?**
   - Local files / local database / iCloud / your own backend
   - Follow-up: is there existing data that must be migrated? (→ schema versioning)
7. **Is there any algorithm or rule that must be exactly right?**
   - Sorting, pricing, time arithmetic → pure functions with locked-down tests

## Group 3 — Look and language

8. **Any visual reference?** (an app / a style / a screenshot)
   - Be explicit: "feels like a native Apple app" or "its own brand"
9. **UI language? Localization needed?**
   - If yes → use key-based localization from Day 0 (**never use the Chinese copy as the key**,
     or logic that matches on Chinese strings silently falls through in English)
10. **Dark mode following the system? Switchable accent color?**
    - If yes → semantic colors + a theme architecture from Day 0; no hardcoded colors

## Group 4 — Cadence and expectations

11. **Iteration cadence?** One-shot delivery / long-term polish
    - Long polish → git tags + CHANGELOG + a component library are mandatory
12. **How much time do you have? When must it be usable?**
    - Decides whether to start with a vertical slice or a feature list
13. **Do you have an Apple Developer account?**
    - If not → no signing/notarization; teach users "right-click → Open" or
      `xattr -dr com.apple.quarantine`

## Tech-stack decision table

| Constraint | Recommended | Avoid |
|---|---|---|
| macOS native, App Store | SwiftUI + AppKit interop | Qt/PySide (LGPL + frozen packaging conflicts) |
| macOS native, personal use | SwiftUI (or Tauri, whichever you know) | Electron (large, non-native feel) |
| Cross macOS + Windows | Tauri / Electron / Flutter | Pure SwiftUI |
| Web + mobile | React/Next + Capacitor | Desktop-native frameworks |
| Heavy computation | Rust/C++ core + thin UI | Pure scripting |
| Fastest prototype | Python + an existing UI framework | Building architecture from scratch |

**The second factor in the stack: the environment.** Run the "environment reconnaissance" in
`references/day-zero.md` first — confirm the machine can compile, package, and sign before you
commit to a stack.

## PROJECT.md template

```markdown
# <Project name>
## One sentence
<what it does, for whom, solving what>

## Users / platform / distribution
- Users: <only me / friends / public>
- Platform: <macOS 14+>
- Distribution: <zip to friends / App Store / web>

## Core features (≤3)
1. ...
2. ...
3. ...

## Non-goals (explicitly not doing)
- ...

## Tech stack
- Language/framework: ...
- Storage: ...
- Packaging: ...

## Acceptance criteria
- <measurable: e.g. "no dropped frames scrolling 1000 tasks">

## Milestones
- M1 core flow working end to end (vertical slice)
- M2 visual polish
- M3 package and distribute
```

## Common failure modes

- **Asking about features but not distribution** → halfway through, you discover it can't ship and
  must rewrite
- **Not asking about data migration** → users lose data when the product is renamed or a column is
  added
- **Not asking about language** → UI copy scatters everywhere when localization is added later
- **Not asking about non-goals** → infinite feature creep, never ships
