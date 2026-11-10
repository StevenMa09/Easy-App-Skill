# App icons, artwork, and technical integrations

Source: HIG (captured 2026-11-10). The icon section comes from the `app-icons` page, read section by
section; the technical part draws on widgets / live-activities / app-clips / siri /
sign-in-with-apple / apple-pay / machine-learning / generative-ai.

## A. App icons and artwork

### Layers

- iOS / iPadOS / macOS / watchOS: **a background layer + ≥1 foreground layer**.
- tvOS: **2–5 layers** (parallax needs separation between layers).
- visionOS: a background layer + 1–2 upper layers; the upper layers' alpha drives embossing and
  inter-layer shadows.

### Canvas

| Platform | Shape you supply | System shape | Size |
|---|---|---|---|
| iOS / iPadOS / macOS | Square | Rounded rectangle | 1024×1024 px |
| tvOS | Landscape rectangle | Rounded rectangle | 800×480 px |
| visionOS | Square | Circle | 1024×1024 px |
| watchOS | Square | Circle | 1088×1088 px |

### Liquid Glass effects

- Highlights, refraction, translucency, blur, and shadows are **all generated dynamically by the
  system**, adjustable per layer or per group.
- Layers must be square (rectangular on tvOS). **Pre-cutting your own rounded corners breaks
  highlights and produces jagged edges.**

### Icon Composer workflow

Import foreground layers → set the background (solid or gradient) → adjust placement → add highlights
and refraction → annotate default / dark / mono → preview across OS versions → export for Xcode.

tvOS and visionOS go through Xcode image stacks plus Parallax Previewer / Exporter. Use SVG/PDF for
vectors and PNG for bitmaps and mesh gradients.

### Must avoid

Feathered edges, self-added shadows/bevels/glows, photos or screenshots as icons, replicating system
UI, Apple hardware, extremely thin lines and sharp corners, unnecessary text (no Watch / Play / New /
For visionOS; tvOS text must sit at the top), pure black backgrounds on watchOS, concave backgrounds
on visionOS, off-center content.

### Appearance variants

Six: default, dark, clear (light/dark), tinted (light/dark). Alternate icons need all six too.

Color spaces: sRGB, Gray Gamma 2.2, Display P3 (P3 only for four platforms plus tvOS). A non-layered
bitmap gets segmented into two layers by the system.

## B. Interface specs for technical integrations

### Widgets

- Size classes: five system sizes + four accessory sizes (circular / corner / inline / rectangular).
- Margins 16 (11 for compact); minimum text 11 pt; update animation ≤2s.
- iOS: 170×170, 364×170, 364×382, 76×76, 172×76, 257×26.
- iPad: canvas 141×141 up to 188×188; extra large 795×378.5.
- visionOS: 158×158 up to 450×338, scalable 75–125%.
- watchOS: 152×69.5 up to 198×81.5.

### Live Activities

- Must support compact / minimal / expanded / Lock Screen.
- The Dynamic Island is black; one compact side is 62.33×36.67, shrinking into a 28 pt circle when
  space is constrained.
- Lock Screen margin 14, height 84–160; at most 3 minimal items.
- Lifecycle: **≤8 hours**, then up to 4 more hours after it ends (15–30 minutes recommended).
- Scales 2× in StandBy; animation ≤2s; at most about one interactive element.

### App Clips

- Card image 1800×1200 px, PNG/JPEG, no transparency.
- Title ≤30 characters, subtitle ≤56; verbs are View / Play / Open.
- Can send notifications for **8 hours**.
- Not allowed: tab bars, launch screens, web views, mandatory sign-up.
- Print: code ≥3/4 inch (1.9 cm), digital image 256×256 px, NFC ≥35 mm, distance ratio ≤20:1, raster
  ≥600 ppi, print ≥300 dpi.

### Siri

- Integrate via AppIntents + App Schema.
- No advertising, don't speak the app name, don't impersonate Siri, never translate "Siri" (translate
  only "Hey").

### Sign in with Apple

- Button ≥140×30; outer margin is 1/10 of the height.
- Text size = 43% of button height (button height = 233% of text size).
- Title is at least 8% of the width from the right edge.
- Three copy variants, three styles (black, white, white with border).

### Apple Pay

- Button width ≥100 (mark only) or 140, height 30, outer margin 1/10 of the height.
- Web icon 60×60 (120/180 px at @2x/@3x).
- Error messages ≤128 characters.
- Mark whitespace is 1/10 of the height, and the mark itself cannot be the button.

### Machine learning and generative AI

- **Explicit feedback**: voluntary, takes effect immediately, persists.
- **Implicit feedback**: multiple signals, recency-weighted.
- Calibrate once, and allow cancelling.
- Must provide: a correction path, multiple options (most likely first), objective attribution, and an
  up-front statement of limitations.
- Generative AI: **label output as AI-generated**, prefer on-device, guard against hallucination,
  confirm before irreversible actions, and offer Undo / Retry.

### Motion extras

- Can be turned off; fall back to haptics/audio.
- Games hold 30–60 fps.
- Avoid sustained oscillation around 0.2 Hz.
- visionOS: avoid motion at the edges of the field of view.
