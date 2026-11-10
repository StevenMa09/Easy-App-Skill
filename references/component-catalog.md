# Shared component catalog (`assets/swift/`)

Source: a real macOS project (a reminders-style app), with all project dependencies removed.
**Verified: the whole library compiles and links; the six assertions for
`HourMinuteField.resolveMinutes` pass.**

## How to adapt

```bash
mkdir -p Sources/DesignSystem
cp -R ~/.dsh/skills/easy-app/assets/swift/*.swift Sources/DesignSystem/
```

Only two things need changing:
1. **Localization**: replace copy with your `L10n.t(...)` / `NSLocalizedString`
2. **Theme color**: change the default of `tint: Color = .accentColor` to your accent

---

## 1. `MotionKit.swift`

| API | Purpose |
|---|---|
| `Motion.check / row / reorder / hover / panel / theme` | Unified durations and easing |
| `Motion.of(_:)` | Honors Reduce Motion (caches the system query — **never** call `NSWorkspace` per frame) |
| `Motion.refreshReduceMotion()` | Call once when the system preference changes |
| `PressableStyle` / `.pressable(scale)` | 0.97 press scale + 0.86 opacity |

## 2. `FormControls.swift`

| Component | Purpose | Key detail |
|---|---|---|
| `SegmentedField<Item>` | Custom segmented control | Selected pill slides via `matchedGeometryEffect`; quieter than the system control |
| `MenuField<Item>` | Quiet dropdown with checkmarks | Hover darkening; closes on popover dismiss |
| `ToggleSwitch` | Custom switch | Follows the theme color |

## 3. `TimeInput.swift`

| Component | Purpose | Key detail |
|---|---|---|
| `HourMinuteField` | Hour:minute input, 12/24-hour + AM/PM | Conversion is a pure function `resolveMinutes(...)`, unit-testable; AM/PM buttons use `.fixedSize()` to avoid wrapping |
| `DayField` | Date field | Opens a calendar popover; nicer than a system compact picker |
| `DayPickerPopover` | Calendar popover | Easy to add "Today / Tomorrow / Next Monday" shortcuts |

**Test cases that must pass** (verified):
```
9:30 PM → 21:30       9:30 AM → 9:30
12:00 AM → 0          12:00 PM → 720
24h overflow → clamped to 23:00
cap of 600 does not affect normal input
```

## 4. `GlassKit.swift`

| API | Purpose |
|---|---|
| `VisualEffectView` | SwiftUI wrapper around `NSVisualEffectView` |
| `.frostedBackground(material:wash:panel:panelOpacity:)` | Frosted glass + optional theme tint; the tint sits **under** the content so text stays clean |

Warning: `.behindWindow` needs a window that can be sampled; on an opaque window it degrades to a
gray slab. Prefer the native sidebar material.

## 5. `ToastBanner.swift`

| API | Purpose |
|---|---|
| `ToastBanner(message:actionTitle:onAction:onDismiss:)` | Bottom `.regularMaterial` capsule, typically "Deleted · Undo" |

---

## What to extract next

These would be worth adding the same way:

- `EmptyStateView` (icon + title + description + optional primary button)
- `ConfirmSheet` (destructive confirmation with "don't ask again")
- `SearchField` (with clear button and focus styling)
- `SidebarRow` (icon + title + count + selection pill)
- `MetricsCard` (statistics card shell: title + content + min height)
- `NumberStepper` (easier to hit than the system Stepper)
- `ColorSwatchPicker` (a row of dots to pick a color)

Extraction rule: **pull a control out the moment a second screen needs it** — don't abstract ahead of
need.
