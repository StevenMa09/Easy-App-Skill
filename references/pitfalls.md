# Pitfall catalog (verified in real projects)

Format: **symptom → root cause → correct approach**.
Check here first when something breaks; it saves a lot of time.

---

## 1. SwiftUI / AppKit

### 1. Dynamic colors resolve against the wrong appearance
- **Symptom**: a light theme renders dark color values, or vice versa
- **Root cause**: deciding light/dark with `NSApp.effectiveAppearance`, while a window may carry its
  own appearance
- **Fix**: use `NSColor(name:dynamicProvider:)` so colors resolve **at draw time**, per context

```swift
NSColor(name: nil) { appearance in
    let dark = appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
    return dark ? NSColor(...) : NSColor(...)
}
```

### 2. Frosted material doesn't work — it's just a gray rectangle
- **Symptom**: `NSVisualEffectView(material: .sidebar, blending: .behindWindow)` looks flat gray
- **Root cause**: the window is opaque, so there is nothing to sample; or the list's own background
  was never hidden
- **Fix**:
  - Prefer the native sidebar material (`List(.sidebar)` with its default background)
  - For custom tinting: `.scrollContentBackground(.hidden)` + your own material, and on an opaque
    window switch to `.withinWindow`
  - Verify in both light and dark, with a real-device screenshot

### 3. System selection highlight can't be restyled
- **Symptom**: `.tint()` tried three times; the selected row stays system gray/blue
- **Root cause**: macOS `List` selection is drawn by `NSTableView`; `tint` only shifts the accent,
  the material layer is out of reach
- **Fix**: either accept the system selection (recommended — it keeps keyboard navigation) or go
  fully custom (`onTapGesture` + `listRowBackground`) and **accept the loss of arrow-key navigation**

### 4. Custom-drawn rows swallow drag gestures
- **Symptom**: after wrapping rows in `Button`, `.onMove` reordering stops working
- **Root cause**: the Button intercepts the drag gesture
- **Fix**: use `HStack + contentShape + onTapGesture` instead of a Button, or implement explicit
  `.draggable` + `.dropDestination`

### 5. Animation causes jank
- **Symptom**: scrolling drops frames after adding animations
- **Root cause**: an expensive operation (cross-process query, formatting, sorting) lives inside a
  function that runs on every frame or every body evaluation
- **Fix**: everything that may be called per frame must be a cheap, pure computation; cache queries
  like `NSWorkspace` and refresh them only when the preference changes

### 6. Black band at the top in fullscreen
- **Symptom**: a black strip across the top of the window in fullscreen
- **Root cause**: the window background doesn't match the content
- **Fix**: `window.backgroundColor = theme.panel`. If the titlebar must remain draggable, do not
  combine `titlebarAppearsTransparent` with content covering the whole window — it eats the drag
  region

### 7. 12/24-hour input in a custom control
- **Symptom**: the setting is switched to 12-hour but the field stays 24-hour
- **Root cause**: display formatting and input control are two separate implementations
- **Fix**: one component owns display + input + AM/PM, reading the **same** settings source; add pure
  functions for the conversion and test them

### 8. IME (input method) conflicts with Return
- **Symptom**: while composing pinyin, pressing Return submits the uncommitted text
- **Root cause**: `onKeyPress(.return)` runs before the IME handles the key
- **Fix**: check `(NSApp.keyWindow?.firstResponder as? NSTextView)?.hasMarkedText()` first and
  `return .ignored` while composing

### 9. Static global state and theming
- **Symptom**: parts of the UI don't refresh after a theme change
- **Root cause**: colors live in `static var` and views don't observe them
- **Fix**: force a rebuild on theme change (`.id(revision)`) or inject via Environment — pick one and
  be consistent

---

## 2. Data layer

### 10. Schema drift
- **Symptom**: columns get added with ad-hoc `ALTER TABLE` and nobody knows the current version
- **Fix**: use `PRAGMA user_version` + `migrate(from:to:)` from Day 0, one function per version

### 11. Renaming the product loses user data
- **Symptom**: after renaming the app, the user's data is gone
- **Root cause**: the data directory / sandbox path moved with the name
- **Fix**: at launch, if the new directory is missing and the old one exists, migrate it and keep a
  backup of the old one

### 12. Seed data contaminates tests
- **Symptom**: removing sample data breaks a pile of tests
- **Fix**: tests create their own data; sample data is injected only on dev/demo paths, and the
  shipped product starts empty

### 13. Time-zone traps
- **Symptom**: all-day tasks become "overdue" the moment midnight passes
- **Root cause**: comparing raw timestamps
- **Fix**: compare natural days (`startOfDay`) for all-day items, and test today/yesterday/cross-zone

### 14. Dictionary literals with duplicate keys
- **Symptom**: crash at launch
- **Root cause**: duplicate keys in a `[String: String]` literal
- **Fix**: build localization tables from an array with
  `Dictionary(entries, uniquingKeysWith: { a, _ in a })`

---

## 3. Algorithms and configuration

### 15. Hardcoded weights and thresholds
- **Fix**: keep magical numbers in `Weights` / `Config`, annotate *why* each value is what it is, and
  lock behavior with at least one test

### 16. Linear models on long-tailed data
- **Symptom**: duration estimates get dragged around by a few very long tasks
- **Fix**: take the log of durations; report quantiles (P50/P80) instead of the mean

### 17. Using localized copy as a logic key
- **Symptom**: in English, a `switch` over Chinese label strings falls through to `default` (all
  colors turn purple)
- **Fix**: match on stable keys/enums; copy is for display only

---

## 4. Build and release

### 18. Silent build failure
- **Symptom**: you believe the build succeeded but an old binary is running
- **Root cause**: `build.sh | grep error` misses failures that never print `error:` (e.g. a missing
  brace)
- **Fix**: check `$?`, use `set -e`, and **assert the version after building**

### 19. Two sources of truth for the version
- **Symptom**: the UI shows 2.1 while the bundle is 3.7
- **Fix**: single source (bundle metadata); the UI reads it

### 20. SDK capabilities never verified
- **Symptom**: a design depends on an API the SDK doesn't have
- **Fix**: grep the interface files before starting; `xcrun --show-sdk-path` and search the
  `.swiftinterface`

### 21. Icon churn
- **Symptom**: the icon was changed six times
- **Fix**: settle the icon on Day 0; use Icon Composer (`.icon`) or a 1024 PNG + `iconutil`; **offer
  several candidates at once**; archive old icons with a rollback script

### 22. Restricted distribution formats
- **Symptom**: `hdiutil create` fails with `Operation not permitted` in a restricted environment
- **Fix**: verify the packaging chain on Day 0; keep a fallback (zip via `ditto`); document how to
  open unsigned builds (right-click / `xattr`)

---

## 5. Collaboration and communication

### 23. Vague "feels off" requests cause endless round trips
- **Fix**: translate feelings into numbers (see the translation table in feature-loop)

### 24. Ambiguous "roll back" scope
- **Fix**: confirm which layer and which version; show `git diff` of what would be reverted and get
  sign-off first

### 25. Batching several changes before verifying
- **Fix**: one change at a time, so failures stay attributable

### 26. Dumping 20 questions at once
- **Fix**: 3–5 questions per round, in dependency order

### 27. Promising something impossible
- **Fix**: recon the capability boundaries (SDK / sandbox / signing) before committing; say plainly
  "this environment can't do X; the alternative is Y"
