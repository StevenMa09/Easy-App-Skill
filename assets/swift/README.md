# Shared component library (SwiftUI / macOS)

Extracted from a real project, fully compiled and used in production. After copying into a new
project only two things need changing: **the localization function** and **the theme color source**
(marked `ADAPT:` in each file header).

## Files

| File | Contents | Depends on |
|---|---|---|
| `MotionKit.swift` | Motion tokens, Reduce Motion (cached), `PressableStyle` / `.pressable()` | none |
| `FormControls.swift` | `SegmentedField`, `MenuField`, `ToggleSwitch` | MotionKit |
| `TimeInput.swift` | `HourMinuteField` (12/24h + AM/PM), `DayField` + `DayPickerPopover` | MotionKit |
| `GlassKit.swift` | `VisualEffectView`, `.frostedBackground(...)` | none |
| `ToastBanner.swift` | Bottom toast (optionally with Undo) | MotionKit |

## Integration

```bash
mkdir -p Sources/DesignSystem
cp -R ~/.dsh/skills/easy-app/assets/swift/*.swift Sources/DesignSystem/
```

1. Replace `.accentColor` with your theme accent (or keep it and pass `tint:` at the call site)
2. Swap copy for your localization calls
3. Call `Motion.refreshReduceMotion()` once when the system preference changes

## Usage

```swift
// Segmented
SegmentedField(items: ["Open-ended", "Timed"], label: { $0 }, selection: $mode)

// Dropdown
MenuField(items: lists, label: { $0.name }, selection: $selectedList)

// Time (follows the 12-hour setting)
HourMinuteField(minutes: task.minutesOfDay,
                showsPeriod: !settings.uses24Hour) { task.minutesOfDay = $0 }

// Date
DayField(date: task.dueDate) { task.dueDate = $0 }

// Switch
ToggleSwitch(isOn: $enabled)

// Press feedback
Button("Save") { save() }.pressable()

// Frosted glass
someList.frostedBackground(wash: theme.accent.opacity(0.1),
                           panel: theme.panel, panelOpacity: 0.75)
```

## Pitfalls already handled

- 12/24-hour conversion is a pure function `HourMinuteField.resolveMinutes(...)`, so it can be unit
  tested
- AM/PM buttons use `.fixedSize()` so the HStack never squeezes them into a wrap
- `Motion.of(...)` caches the system query, so checking accessibility settings doesn't tank scroll
  performance
- `PressableStyle` scales no lower than ~0.94, otherwise presses look like jitter
- The `.behindWindow` limitation of frosted materials is documented at the top of `GlassKit.swift`

## Suggested tests (pair with the Day-0 selftest)

```swift
check(HourMinuteField.resolveMinutes(hour: 9, minute: 30, isPM: true,
                                     showsPeriod: true, maxMinutes: 1439) == 21 * 60 + 30,
      "12h 9:30 PM → 21:30")
check(HourMinuteField.resolveMinutes(hour: 12, minute: 0, isPM: false,
                                     showsPeriod: true, maxMinutes: 1439) == 0,
      "12:00 AM → midnight")
```
