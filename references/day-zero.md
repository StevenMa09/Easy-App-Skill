# Phase 1 — Day 0 foundation checklist

Goal: within half a day to a day, land everything that "will definitely be needed later and is
cheapest to do now". Every item has **acceptance criteria**; do not start features until they pass.

---

## 1. Git + versioning (30 minutes)

```bash
git init
printf '.build/\ndist/\n*.o\n.DS_Store\n' > .gitignore
git add -A && git commit -m "v0.1.0: initial commit"
git tag v0.1.0
```

- Semantic versioning: bug fix → patch (3.7.6→3.7.7); new feature → minor (3.7→3.8); rewrite → major
- Every change: commit + tag + update `CHANGELOG.md`
- Rollback = `git checkout vX.Y.Z && ./build.sh` — one command

**Acceptance**: `git tag` lists the first version; `CHANGELOG.md` has a v0.1.0 entry.

> Skip this and "roll back" becomes archaeology. In a real project, git was only introduced when the
> user said "roll back" for the third time — by then the earlier versions were unrecoverable.

## 2. One-command verify pipeline (1 hour)

`verify.sh`:

```bash
#!/bin/bash
set -euo pipefail
echo "▸ build";   ./build.sh
echo "▸ test";    ./dist/App.app/Contents/MacOS/App --selftest
echo "▸ version"; /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
                    dist/App.app/Contents/Info.plist
echo "▸ render";  ./dist/App.app/Contents/MacOS/App --render dev/shots
echo "✓ all green"
```

Rules:
- **`set -e`**: stop on the first failure
- **Check the exit code**, never `cmd | grep error` (it misses failures that don't print `error:`,
  e.g. a missing brace)
- **Assert the version**: `[ "$VER" = "$EXPECTED" ]`, so you never ship a stale bundle
- Support dev entry points like `--selftest` / `--render` so UI projects can be automated

**Acceptance**: introduce a deliberate compile error; `./verify.sh` must fail at the build step with
a non-zero exit code.

## 3. Single source of truth for the version (15 minutes)

- The version lives only in bundle metadata (`Info.plist` / `package.json` / `Cargo.toml`)
- Code reads it: `Bundle.main.infoDictionary?["CFBundleShortVersionString"]`
- UI display, logs, and chat reports all reference that same source
- **Never hardcode a version string in the UI**

**Acceptance**: change the version in one place; the About panel and `verify.sh` output both change.

## 4. Design tokens (2 hours)

Create `DesignSystem/Tokens.swift` and define, once:

```swift
enum Radius { static let s: CGFloat = 6; static let m: CGFloat = 10; static let l: CGFloat = 14 }
enum Spacing { static let xxs: CGFloat = 4; static let xs = 8; static let s = 12
               static let m = 16; static let l = 24 }   // 8pt grid
enum TypeScale { static let title = Font.system(size: 22, weight: .semibold)
                 static let body = Font.system(size: 13)
                 static let caption = Font.system(size: 10.5) }
enum Motion { /* durations + easing, see assets/swift/MotionKit.swift */ }
```

Colors **must be semantic**, never raw `.blue`:

```swift
enum Palette {
    static var surface: Color      // content background
    static var panel: Color        // sidebar / inspector
    static var card: Color         // cards
    static var textPrimary: Color
    static var textSecondary: Color
    static var accent: Color
    static var danger: Color
}
```

**Acceptance**: search the business code for `Color(hex:` / `.blue` / `#` — there should be zero hits.

> Cautionary tale: colors were written as `static let accent = Color(hex: "#0088FF")`. When 7 themes
> were requested later, the global replacement plus dynamic-color resolution bugs cost 6 rounds of
> conversation.

## 5. Theme architecture (2 hours, do it together with #4)

- Support both light and dark appearances (use `NSColor(name:dynamicProvider:)` or SwiftUI semantic
  colors — **not** `NSApp.effectiveAppearance` to decide light vs dark)
- Switchable accent color → everything goes through `Palette.accent`
- Theme changes must take effect **immediately** (window appearance + `preferredColorScheme` belt and
  braces)

**Acceptance**: toggling appearance updates the UI instantly with correct colors (a light theme must
not be rendering dark color values).

## 6. Component library (half a day)

Copy from `assets/swift/`, then adjust the two `ADAPT:` spots (localization function, theme color
source).

The nine essentials (all verified in a real project):

| Component | Why it's essential |
|---|---|
| `SegmentedField` | System segmented controls look stiff and can't be re-tinted |
| `MenuField` | System dropdowns are boxy buttons that clash with custom UI |
| `ToggleSwitch` | System switches can't follow the theme color |
| `HourMinuteField` | 12/24-hour + AM/PM; no system control does this |
| `DayField` + calendar popover | Better than a system compact date picker |
| `PressableStyle` | 0.97 press scale — consistent feedback on every button |
| `Motion` tokens + reduce-motion | Consistent timing + accessibility |
| `GlassPanel` (VisualEffectView) | Frosted sidebar / inspector |
| `ToastBanner` | Undo prompts and action feedback |

**Acceptance**: new screens only call these components; no system `Picker(.segmented)` or
`Toggle(.switch)` remains.

## 7. Environment reconnaissance (30 minutes — **do this before promising a stack**)

```bash
xcrun --show-sdk-path            # SDK version → which APIs exist
xcode-select -p                  # full Xcode or only Command Line Tools
xcrun -f actool iconutil         # icon / asset tooling available?
swift --version                  # compiler version
```

Checklist:
- [ ] Compile chain works (hello world → executable)
- [ ] Packaging chain works (.app / .exe / bundle)
- [ ] Icon assets compile (`.icns` / `.ico` / PNG)
- [ ] Signing capability (developer certificate? ad-hoc?)
- [ ] Sandbox boundaries: network, `hdiutil`, opening windows, screenshots
- [ ] The system APIs you plan to use actually exist in this SDK (**grep the interface files before
      designing around them**)

**Acceptance**: write one sentence — "in this environment I can deliver to <distribution form>."

> Real lesson: an iOS-26 `glassEffect()` design was built before discovering the SDK was 15.2 and
> the API didn't exist; `actool` also didn't understand the newer `.icon` format. Discovering this
> after building it meant building it twice.

## 8. Data layer (2 hours)

```swift
// Create this from the first table: schema version + migration
let version = PRAGMA user_version
if version < 2 { migrateV1toV2() }
```

- Every table carries `id`, `created_at`, `updated_at` from day one
- Reserve columns that future statistics will need: `started_at`, `completed_at`,
  `actual_minutes`, `estimate_minutes`
- Seed data policy: **the shipped product starts empty**; sample data is for dev/demo paths only
- Data directory: decide the product name and bundle id on Day 0 to avoid migration later

**Acceptance**: the app starts cleanly both with a fresh database and when upgrading an old one.

## 9. Distribution chain (half a day, together with #7)

- Decide the installer format: DMG / zip / MSI / web
- Write packaging as a command: `./package.sh` → a distributable artifact
- Signing + notarization: try it on Day 0, not the day before release
- Document how to open an unsigned build (right-click → Open / `xattr -dr com.apple.quarantine`)

**Acceptance**: the built artifact runs on a second machine.

---

## Day 0 done means

```bash
./verify.sh                 # all green
git tag                     # v0.1.0 exists
ls Sources/DesignSystem/    # tokens + the nine components
cat PROJECT.md              # 10 lines or fewer
```

After that: one feature → run `verify.sh` → tag a version.
