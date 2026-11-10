# Foundations: color, type, layout, materials, motion, accessibility

Source: the official HIG pages (captured 2026-11-10). Every number below comes from the original
text; anything the original does not specify (e.g. animation durations and easing) is explicitly
marked "not specified" rather than invented.

## Color

- Use system semantic colors; **never hardcode hex values**. Custom colors must ship three variants:
  light, dark, and increased contrast.
- Backgrounds step through system / grouped levels (primary, secondary, tertiary); text uses the four
  label levels.
- **Color must never be the only information channel** — pair it with text or shape.
- Accent color is reserved for the primary action and for state; don't tint multiple control
  backgrounds on one screen.
- Wide-gamut: Display P3, 16 bits per channel, deliver as PNG.

## Type

**Default / minimum sizes**

| Platform | Default | Minimum |
|---|---|---|
| iOS / iPadOS | 17 / 11 pt | 17 / 11 |
| macOS | 13 / 10 pt | 13 / 10 |
| tvOS | 29 / 23 pt | 29 / 23 |
| visionOS | 17 / 12 pt | 17 / 12 |
| watchOS | 16 / 12 pt | 16 / 12 |

**iOS default (Large) size / line height**

| Style | Size | Line height |
|---|---|---|
| Large Title | 34 | 41 |
| Title 1 | 28 | 34 |
| Title 2 | 22 | 28 |
| Title 3 | 20 | 25 |
| Headline | 17 | 22 (semibold) |
| Body | 17 | 22 |
| Callout | 16 | 21 |
| Subhead | 15 | 20 |
| Footnote | 13 | 18 |
| Caption 1 | 12 | 16 |
| Caption 2 | 11 | 13 |

**macOS**: Body 13/16, Title 1 22/26, Large Title 26/32, Caption 10/13.

- Dynamic Type range: Body from 14 pt (xSmall) to 23 pt (xxxLarge); from AX1, Large Title is 44/52.
- Custom fonts are fine for headings; **use the system font for body text**.
- Don't use tight leading for anything longer than three lines.

## Layout

- Decide with **size classes** (compact / regular), not with specific devices or orientations.
- Backgrounds extend under sidebars, toolbars, and tab bars; separate regions with a **scroll edge
  effect**, not with a drawn divider.
- **tvOS**: safe-area insets 60 pt top/bottom and 80 pt left/right.
- **tvOS grid**: 40 pt horizontal spacing, ≥100 pt minimum vertical spacing. Column widths — 2
  columns 860, 3: 560, 4: 410, 5: 320, 6: 260, 7: 217, 8: 184, 9: 160 pt.
- **visionOS**: button centers at least 60 pt apart.
- **watchOS**: at most 3 icon buttons or 2 text buttons in one row.
- **macOS**: don't put critical controls at the bottom of a window.

## Materials and depth (Liquid Glass)

- **Glass belongs to the control and navigation layer only**; the content layer uses standard
  materials, not glass.
- Four standard material levels: `ultra-thin`, `thin`, `regular` (default), `thick`. Thicker = more
  contrast, thinner = more transparency.
- On bright backgrounds add a **dark dimming layer at 35% opacity**.
- Lots of text or a busy background → use the `regular` variant; pure media background → use the
  `clear` variant.
- Text vibrancy has three levels: default, secondary, tertiary; **never use quaternary on ultra-thin
  or thin**.

## Motion

- Games should hold a steady 30–60 fps.
- **Avoid continuous oscillation around 0.2 Hz** — humans are especially sensitive to it. If it is
  unavoidable, reduce the amplitude or convert it into content movement.
- **The original text does not specify animation durations or easing** — do not invent numbers.
  System components carry their own start/end easing.
- With Reduce Motion enabled: tighten springs, let animations follow the gesture, replace
  translation with cross-fades, don't animate blur, and drop z-axis depth.
- Motion must not be the only information channel; pair it with haptics or audio, and allow skipping.

## Dark mode

- Contrast ≥ **4.5:1**; for custom foreground/background pairs on small text ≥ **7:1**.
- **Don't build an in-app appearance switch**; follow the system light / dark / auto setting.
- iOS dark mode has base and elevated backgrounds; use elevated for foreground UI.
- Supply both light and dark artwork; a white-background image should be slightly dimmed in dark mode.
- Re-test dark-mode text legibility with Increase Contrast and Reduce Transparency both on.

## Icons and images

- Interface icons: PDF / SVG vectors.
- Bitmap scales: iOS @2x/@3x, iPadOS and watchOS @2x, macOS and tvOS @1x/@2x, visionOS ≥ @2x
  (beyond @6x hurts performance).
- **macOS document icons**: canvases 512 / 256 / 128 / 32 / 16 px (plus @2x); the center image is half
  the canvas, the main subject occupies 80% with 10% margins, still legible at 16 px.
- **SF Symbols**: 9 weights, 3 scales (default medium), 4 rendering modes (monochrome / hierarchical /
  palette / multicolor); symbol weight must match adjacent text.
- tvOS layered images use 2–5 layers; the background layer must be opaque.
- Formats: de-interlaced PNG; 8-bit palette when full 24-bit color isn't needed; JPEG / HEIC for
  photos; stereo HEIC for spatial photos.
- Don't tile a repeated logo; don't use the launch screen for branding.

## Accessibility

**Control sizes (default / minimum)**

| Platform | Regular | Minimum |
|---|---|---|
| iOS / iPadOS | 44×44 pt | 28×28 pt |
| macOS | 28×28 pt | 20×20 pt |
| tvOS | 66×66 pt | 56×56 pt |
| visionOS | 60×60 pt | 28×28 pt |
| watchOS | 44×44 pt | 28×28 pt |

- Control spacing: about 12 pt around bordered controls, 24 pt around borderless ones.
- Contrast: 4.5:1 for text ≤17 pt; 3:1 for 18 pt and above or bold text.
- Text must scale to at least **200%** (watchOS 140%).
- Keep gestures simple for common actions and always provide an equivalent button.
- RTL: paragraphs of three lines or more align by language; Arabic/Hebrew next to all-caps Latin
  text needs +2 pt.
- Mirror "direction/progress" icons; **do not flip** logos, checkmarks, or other universal symbols
  and photos.

## Copy

- Address the reader as you / your, not "the user"; avoid we.
- Button labels are verbs: `Send`, not `Let's do it!`; links never say `Click here`.
- Errors offer a fix: `Choose a password with at least 8 characters`.
- Say "tap" for touch, not "click"; title case vs sentence case must be consistent app-wide.
- Permission prompts: one complete sentence in active voice, sentence case, ending with a period.

## Privacy

- Request only the data the feature actually needs, **and only when the user reaches that feature** —
  never at launch.
- A pre-permission screen has a single button, `Continue` / `Next`, never `Allow`.
- Prohibited (App Review rejects): incentivized requests, impersonating system dialogs, screenshots
  of dialogs, pre-checked background disclosure.
- Sensitive data goes in the keychain; never store passwords in plain text; prefer passkeys, 2FA, and
  biometrics.
- Process on-device whenever possible.

## The eight design principles (as stated in the source)

| Principle | What it means in practice |
|---|---|
| Purpose | Define who it serves and what it solves first; delete features that don't serve that |
| Agency | Don't lock users into one path; allow skipping, undoing, going back |
| Responsibility | Explain what is collected and why at the first interaction |
| Familiarity | Reuse established patterns; the same element behaves the same app-wide |
| Flexibility | Treat accessibility as a day-one priority: voice, touch, keyboard |
| Simplicity | Simple ≠ minimal; keep only what's necessary |
| Craft | Copy, animation, and audio polished to the same standard |
| Delight | Set an emotional goal first; decoration is not delight |

## Platform differences at a glance

- **iOS**: single column, full screen, gesture-first, tab bar with 3–5 items.
- **iPadOS**: split view (sidebar + detail), drag and drop, pointer and keyboard support.
- **macOS**: windows, menu bar, high-precision pointer, smaller controls (28 pt), higher information
  density.
- **watchOS**: one task per screen, vertical scrolling, horizontal paging for peer views.
- **tvOS**: focus-driven (not touch); all interaction moves focus with the remote.
- **visionOS**: windows and volumes in space, button spacing ≥60 pt, avoid making people turn their
  heads repeatedly.
