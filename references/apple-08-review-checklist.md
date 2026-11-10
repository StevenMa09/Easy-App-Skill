# Review checklist

Walk it before delivery. **P0 items block shipping; P1 items are recommendations.**

## A. Structure

- [ ] **P0** Each screen has one idea / one hero element. If you can't state what the screen is about,
      it isn't done.
- [ ] **P0** There is exactly one primary action, and it clearly dominates the others.
- [ ] P1 Anything deletable has been deleted. If it can't be deleted, justify it.
- [ ] P1 Hierarchy comes from size, weight, and whitespace — not from boxes and tinted blocks.

## B. Visual

- [ ] **P0** Everything colored is tappable; no decoration is tinted.
- [ ] **P0** At most 2 tinted control backgrounds per screen.
- [ ] **P0** Glass appears only in the functional layer (bars, popovers, buttons); content cards are
      solid.
- [ ] **P0** Dark mode is not pure black plus pure white text (body text sits around `#f5f5f7`).
- [ ] P1 Separators are 0.5–1px at low opacity and inset to align with text.
- [ ] P1 Corner radii follow a system (card, cell, capsule) rather than ad-hoc values.

## C. Components

- [ ] **P0** Hit areas meet the minimum: iOS 44×44, macOS 28×28, visionOS 60×60, watchOS 44×44 pt.
- [ ] **P0** Switches appear only inside list rows — never in toolbars or cards.
- [ ] **P0** Buttons are capsules or filled rounded rects — not 1px outlined rectangles, and no
      ripples.
- [ ] **P0** Dialogs with destructive actions include Cancel, and Cancel is not the default button.
- [ ] P1 Alerts have ≤3 buttons and titles of ≤2 lines.
- [ ] P1 Tab bars hold 3–5 items with no More overflow.
- [ ] P1 Toolbar titles are ≤15 characters and split into ≤3 groups.
- [ ] P1 Segmented controls have ≤5 segments on iPhone.

## D. Interaction and motion

- [ ] **P0** Every press has visible feedback (dimming or a slight scale) — nothing feels dead.
- [ ] **P0** With Reduce Motion enabled, animations are degraded or disabled.
- [ ] P1 Motion is fast in and fast out (about 0.2–0.4s), with no elastic overshoot.
- [ ] P1 Exit direction matches entry direction (leave the way you came in).
- [ ] P1 Motion is never the only information channel; pair it with text or haptics.
- [ ] P1 Every gesture has a discoverable equivalent button.

## E. Accessibility

- [ ] **P0** Body contrast ≥4.5:1; small text or custom palettes ≥7:1.
- [ ] **P0** Color is not the only information carrier (state also has text, shape, or an icon).
- [ ] **P0** Every interactive element is keyboard-reachable and has a visible focus ring.
- [ ] P1 Text scales to 200% without breaking the layout.
- [ ] P1 Icon buttons have accessibility labels; decorative images are marked as such.
- [ ] P1 Every form input has a label, not just a placeholder.

## F. Code (if delivering HTML/CSS)

- [ ] **P0** Colors, radii, and type sizes come from tokens — no scattered hardcoded values.
- [ ] **P0** Floating bars use `position: fixed` + rounded corners + `backdrop-filter`, with content
      passing underneath — not a solid bar glued to the edge.
- [ ] **P0** `env(safe-area-inset-*)` is handled.
- [ ] P1 Dark mode flips via tokens, not per-element overrides.
- [ ] P1 `prefers-reduced-motion` is handled.
- [ ] P1 Weights and icon stroke widths follow a system (icons 1.8–2px, visually matching adjacent
      text).

## G. App icon and artwork

- [ ] **P0** Square layers supplied (rectangular on tvOS) — **no pre-cut rounded corners**.
- [ ] **P0** Canvas sizes correct: 1024² (iOS/macOS/visionOS), 1088² (watchOS), 800×480 (tvOS).
- [ ] **P0** No text (no Watch / Play / New, etc.).
- [ ] P1 All six appearance variants exist (default / dark / clear×2 / tinted×2).
- [ ] P1 No feathered edges, self-added shadows or glows, Apple hardware, or replicated system UI.
- [ ] P1 Still recognizable when scaled to 29pt.

## H. Marketing page (if you're building a landing page)

- [ ] **P0** Each section makes one claim with one hero visual — not a feature list.
- [ ] **P0** No "badge + headline + subhead + two buttons + trust logos + screenshot" stack.
- [ ] **P0** Buttons and navigation have no drop shadows.
- [ ] P1 Alternate light and dark sections; pure-black sections use `#f5f5f7` text.
- [ ] P1 Headlines ≥40px, line width ≤800px, body ≤600px.
- [ ] P1 Exactly one accent color on the whole page.
- [ ] P1 Scroll effects aren't `ease-in-out` and don't bounce.

## The final test

Show a screenshot to someone uninvolved and ask two questions:

1. **"What app is this?"** — if they can't tell, the visual language never landed.
2. **"Where would you tap first?"** — if they point at the wrong thing, the primary action isn't
   obvious.

Get both right, then ship.
