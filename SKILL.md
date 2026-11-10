---
name: easy-app
description: >-
  Easy App — a complete end-to-end protocol for building an application (desktop, mobile, or web):
  clarify requirements from a PM perspective first, lock the design with Apple's official HIG specs
  (real numbers across six platforms + a design review checklist), then lay the engineering
  foundation on Day 0 (git, semantic versions, a one-command verify pipeline, design tokens, a
  component library, schema migration, and the distribution path), and finally iterate in a
  "small change → verify → tag a version" loop, passing the review checklist before delivery.
  Use this skill when the user says "build me an app / tool / software", "rewrite this project",
  "this project needs to ship", "start from scratch", or "make it look like Apple" — or when you
  expect many consecutive iterations on the same project. Also use it for project retrospectives,
  choosing a tech stack, evaluating environment feasibility, and design reviews.
---

# Easy App

**A one-stop protocol for building an app**: requirements → Apple-spec design → Day 0 foundation →
iteration loop → review and delivery.

Three core beliefs:

1. **PM before programmer.** If you haven't nailed down "who is it for, where does it run, how is
   it distributed", the code you write is probably wasted work.
2. **A Day-0 foundation is 10× cheaper than firefighting later.** Git, versioning, a verify
   pipeline, design tokens, a component library, data migration — half a day of cost that saves
   dozens of rework rounds.
3. **Visual requirements must be quantified.** "Too bright" and "looks weird" are not specs.
   Without extracting verifiable numbers, you will loop forever.

## When to use

- The user wants to "build an app / tool / software", or asks to "rewrite / refactor / ship it"
- You expect ≥5 consecutive iterations on the same project
- You need to pick a tech stack, evaluate environment feasibility, or run a retrospective

## Three phases (order matters)

### Phase 0 — Discovery (before any code, 30–60 minutes)

**Ask as a PM. Ask 3–5 questions at a time, never 20 at once.**
The full questionnaire is in `references/discovery.md`. The minimum set:

| Must ask | Why it matters |
|---|---|
| Who uses it — just you, or other people? | Drives UI complexity, error tolerance, onboarding needs |
| Which platform? (macOS / iOS / Web / cross-platform) | Drives the stack, controls, packaging |
| **How is it distributed?** (App Store / hand it to someone / internal / web) | **The most upstream constraint** — decides signing, sandboxing, language, and whether a given framework is even allowed |
| What are the top 3 core features? | Prevents feature creep |
| Where does data live, must it persist long-term, will it migrate? | Drives the data layer design |
| Any visual reference? (an app / a style) | Drives the design-system direction |
| UI language, and does it need localization? | Decides the i18n architecture (decide this on Day 0) |
| What iteration cadence do you expect? (one-shot delivery / long polish) | Decides whether you need git tags and a component library |

**Produce a 10-line `PROJECT.md`**: goal, users, platform, distribution, core features, non-goals,
tech stack, acceptance criteria, milestones.

> Cautionary tale: a project started in Qt/PySide, and halfway through the user said it had to go on
> the Mac App Store — sandboxing conflicted with LGPL, so the whole thing was rewritten in Swift.
> **Not asking about distribution literally means a rewrite.**

### Phase 1 — Day 0 foundation (half a day to a day)

Follow `references/day-zero.md`. All seven blocks must land:

1. **Git + semantic versions + CHANGELOG** (start at the first commit; don't wait for "stable code")
2. **One-command verify pipeline** `./verify.sh`: build → test → version assertion → screenshots →
   package, aborting on the first failure
3. **Single source of truth for the version** (bundle metadata); the UI reads it, never hardcodes it
4. **Design tokens + theme architecture** (semantic color layers, 8pt spacing, radius scale,
   motion durations)
5. **Shared component library** (time input, segmented control, dropdown, switch, toast, press
   feedback — see `assets/swift/`)
6. **Environment reconnaissance**: SDK capabilities, sandbox boundaries, whether the
   build/package/sign chain works at all
7. **Data layer**: schema version + migration function + reserved timestamp columns + seed policy

### Phase 1.5 — Design specs (merged from apple-pro-design / official HIG)

**Look up the table before writing UI — don't go by feel.** The most-used hard numbers are below;
full specs are in `references/apple-0*.md`.

**Five non-negotiables**

1. **Glass is for the functional layer only.** Toolbars, sidebars, and buttons may be glass;
   content cards must be solid.
2. **Color is a signal.** If it's tinted, it must be tappable. At most one or two tinted controls
   per screen.
3. **Minimum hit targets**: iOS 44×44, macOS 28×28, visionOS 60×60, watchOS 44×44 pt.
4. **One hero element per screen.** If it's crowded, delete elements — don't shrink them.
5. **The system draws the corners; don't pre-mask your icon layers.** Supply square layers.

**Hard numbers cheat sheet**

| Item | Value |
|---|---|
| iOS Body / Large Title | 17/22 · 34/41 pt |
| macOS Body | 13/16 pt |
| Grouped list row height | ≥44 pt, separators inset 16 pt |
| Dark-mode contrast | ≥4.5:1 (7:1 for small text) |
| Icon canvas | iOS/macOS/visionOS 1024², watchOS 1088², tvOS 800×480 |
| Corner radius | panel 10–14, control 6–8, capsule = height/2 |
| Motion | 0.2–0.4s, fast out, no elastic overshoot |

**Common failures (seen on both sides)**

- Tinting non-interactive elements → users try to tap them
- Using a 1px stroke as a button outline → that's Material vocabulary, not Apple
- Dark mode as pure black + pure white text → harsh (body text should sit around `#f5f5f7`)
- Dropping system controls (`Picker(.segmented)`, `Toggle(.switch)`) into a custom-drawn UI →
  instantly looks bolted together
- Hand-drawing the selection highlight but losing keyboard navigation → pretty but unusable
  (weigh the trade-off first)

**Keep two kinds of content separate**: `apple-01`–`04` are **specs** (citable, arguable);
implementation recipes are **approximations** that must be verified on the target device.

### Phase 2 — Feature Loop (every change)

Follow `references/feature-loop.md`:

```
read the request → turn it into acceptance criteria → change exactly one thing
→ build (check the exit code) → self-tests → offscreen render → real-device screenshot
→ tag vX.Y.Z → report (with the version number)
```

Four hard rules:

- **Trust the exit code**, not `build.sh | grep error` — grep misses syntax errors and you end up
  running a stale binary
- **Visual changes must be verified on a real window**: offscreen rendering cannot validate
  materials, window behavior, animation, or focus
- **One change at a time**, verified immediately; batch five changes and you lose attribution when
  something breaks
- **Tag every change** so "roll back to version X" is a command, not an archaeology project

## Deciding between "roll back" and "keep fixing"

- When the user says "roll back", they usually mean **one specific layer** (e.g. revert the tint
  layer but keep the drag implementation) → confirm the scope and show them `git diff` first
- Try to **disprove your own hypothesis** before reverting: is it environmental? (Real case: the
  window wouldn't drag — the machine was wedged, a reboot fixed it, the code was fine)
- After a rollback, preserve the other fixes: revert precisely (file/hunk), never overwrite a whole
  directory

## Translating vague feedback into specs

Users describe feelings; convert them into numbers or you'll iterate five times:

| User says | Convert to |
|---|---|
| "Too bright" | Background L* ≤ 30; tint blend ratio ≤ 12% |
| "No depth" | Three surfaces (content / panel / card) differ by ≥6% in lightness |
| "Too busy / not Apple-like" | ≤2 colored elements per screen; everything else neutral, separated by lightness |
| "The button feels stiff" | Borderless capsule + 8% hover fill + 0.97 scale on press |
| "The frosted glass is gone" | Can the material actually sample what's underneath? (`behindWindow` is a no-op when the window is opaque) |
| "The icon looks bad" | Offer **multiple candidates at once** (6–10 side by side) instead of iterating one by one |

**Whenever the change is visual, present several candidates for the user to choose from** — it's
about 5× faster than changing, asking, and changing again.

## Reference files

| File | Contents |
|---|---|
| `references/discovery.md` | PM questionnaire + tech-stack decision table + `PROJECT.md` template |
| `references/day-zero.md` | The seven Day-0 foundations, in detail, each with acceptance criteria |
| `references/feature-loop.md` | The per-change workflow, verification split, reporting format |
| `references/pitfalls.md` | 27 real pitfalls (SwiftUI/AppKit/data/algorithms/build/distribution) |
| `references/component-catalog.md` | Component API list and adaptation notes (with `assets/swift/`) |
| `assets/swift/` | Component sources you can copy in (motion/form controls/time input/glass/toast) |
| `references/apple-01-spec-foundations.md` | Apple foundations: type, color, spacing, materials, contrast (six platforms) |
| `references/apple-02-spec-components.md` | Apple components: buttons, lists, navigation, dialogs |
| `references/apple-03-spec-patterns.md` | Apple patterns: navigation, search, settings, empty states |
| `references/apple-04-spec-icons.md` | App icon specs: canvas, layers, layered design, appearances |
| `references/apple-08-review-checklist.md` | **Design review checklist** (P0/P1) — must pass before delivery |

## Pre-delivery design review (P0 blockers)

Walk `references/apple-08-review-checklist.md` item by item. The P0s most often missed:

- [ ] Each screen has one idea / one hero element
- [ ] Everything tinted is tappable; ≤2 tinted control backgrounds per screen
- [ ] Glass only on the functional layer; content cards are solid
- [ ] Dark mode is not pure black + pure white
- [ ] Hit targets meet the minimum (macOS 28×28, iOS 44×44)
- [ ] Buttons are capsules or filled rounded rects — no 1px outlines, no ripples
- [ ] Destructive actions offer Cancel, and Cancel is not the default
- [ ] Every press has visible feedback
- [ ] With "Reduce Motion" enabled, animations are degraded

**Any failing P0 means: do not ship.**

## How to use the component library

At project start:

```bash
cp -R ~/.dsh/skills/easy-app/assets/swift/ ./Sources/DesignSystem/
```

Then fix the places marked `ADAPT:` in the file headers (your localization function, your theme
color source); everything else works as-is. **These components ran in a real shipped project** —
they are not illustrative pseudo-code.

See `references/component-catalog.md` for the full list: hour:minute input (12/24h + AM/PM), date
popover, segmented control, quiet dropdown, custom switch, press feedback, frosted panel, toast
banner, motion tokens with Reduce Motion support.

## Finally: always report a version number

End every change report with **`Version: vX.Y.Z` plus the rollback command**. That is the user's
safety rope.
