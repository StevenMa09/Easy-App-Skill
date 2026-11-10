# Components: sizes, platform differences, and misuse

Source: HIG (captured 2026-11-10). Unlabeled values are in pt.

## Buttons

- **When**: immediate actions.
- **Size**: hit area ≥ 44×44 (visionOS 60×60). visionOS buttons come in 28 / 32 / 44 / 52 / 64 tiers;
  icons use circles, text uses capsules; centers ≥ 60 apart, plus 4 pt padding beyond that.
- **At most 1–2 prominent buttons per screen.**
- iOS: a button may embed an activity indicator and switch its label to the present participle.
- macOS-only variants: push, square (never in a toolbar), help (≤1 per window), image (10 px image
  margin) — all show a tooltip on hover.
- **Misuse**: using size to signal hierarchy, pairing a destructive action with primary styling, no
  pressed state.

## Tab bars

- **When**: top-level section navigation.
- iOS: floating at the bottom, may include a search tab. iPadOS: top, convertible to a sidebar, up to
  5 self-chosen items.
- tvOS: **68 pt tall, 46 pt from the top of the screen**. visionOS: vertical, hugging the leading
  edge. watchOS: unsupported. macOS: no additional requirements.
- **Misuse**: hiding or disabling items, a More overflow, stuffing actions into the tab bar.

## Toolbars

- **When**: commands, navigation, and search for the current view.
- Structure: leading is not customizable; center collapses into an overflow menu as the window
  narrows; trailing is persistent.
- **Title ≤15 characters; ≤3 groups; exactly one prominent item, in the trailing group.**
- iOS: keep only critical items; large titles shrink on scroll. iPadOS: may share a row with the tab
  bar. macOS: lives in the titlebar with no bezel, and **every item must have a matching menu-bar
  command**. visionOS: at the bottom; no vertical toolbars.
- **Misuse**: hand-rolling an overflow menu, text buttons without separation, using the app name as a
  title.

## Lists and tables

- **When**: browsing, selecting, editing, and reordering grouped or hierarchical data.
- Styles: grouped on iOS, bordered with alternating rows on macOS, elliptical on watchOS; multi-column
  tables use **noun headers**.
- iOS/iPadOS: **rows can only be multi-selected in edit mode**; an info button only reveals
  information, drilling in uses a disclosure indicator; section indexes conflict with trailing row
  controls.
- macOS: click a column header to sort, resizable columns, outline views for hierarchy.
- **Misuse**: long text or multiple images inside a row (use a collection instead).

## Alerts

- **When**: something must be known immediately, or an irreversible confirmation.
- **Title ≤2 lines + optional message + at most 3 buttons**; may include a text field.
- visionOS: accessory height ≤154, corner radius 16.
- Button placement: default at the trailing/top, Cancel at the leading/bottom; **destructive actions
  must offer Cancel**.
- macOS: may include an icon, a suppression checkbox, and Help.
- **Misuse**: informing without any action, showing one at launch, using it for undoable actions,
  substituting it for an action sheet, making Cancel the default.

## Sheets

- **When**: a scoped task related to the current context.
- With a single view, Cancel is leading and Done is trailing — **never both at once**.
- Detents: large plus a roughly half-height medium; a grabber is required when resizable.
- iOS/iPadOS may be non-modal; iPadOS prefers page/form sheets; macOS shows a rounded card, dims the
  parent window, and still allows switching to other windows.
- **Misuse**: multiple sheets on one screen, closing one and immediately opening another, Done without
  a way to cancel.

## Popovers

- **When**: briefly revealing a small amount of information, with an arrow pointing at the triggering
  control.
- Sized to fit the content; **only one at a time, never cascading**; only an alert may appear on top.
- Dismisses on outside click; when non-modal, save before dismissing.
- iOS/iPadOS: regular width only — compact width uses a sheet. macOS: can be dragged out into a panel.
- **Misuse**: using one to raise a warning, stuffing too much functionality inside.

## Menus

- **When**: a space-efficient set of commands.
- Verb-first labels; add an ellipsis when more input is needed; disabled items stay visible and the
  menu still opens.
- **Only one level of submenus**; more than about 5 items should become a separate group.
- iOS/iPadOS three sizes: small (4 items in the top row, no labels), medium (3 icon items + short
  labels), large (default).
- **Misuse**: long menus that aren't split, using indentation instead of submenus.

## Text fields

- **When**: a small amount of specific text.
- **A label is required in addition to the placeholder**; width matches the expected input; multiple
  fields share equal spacing and width.
- Sensitive data uses a secure field; clipping is the default, ellipsis is the alternative.
- iOS: a trailing Clear button; validate email when moving between fields, validate
  username/password before submitting. macOS may use a combo box.
- **Misuse**: no label, jumping tab order, no keyboard type configured.

## Switches / segmented controls / sliders

- **When**: two states (toggle), a few mutually exclusive options (segmented — multi-select allowed on
  macOS), continuous values (slider).
- Segmented controls use equal widths; **up to about 7 segments on wide layouts, and no more than
  about 5 on iPhone**.
- Radio groups hold 2–5 options; more than about 5 becomes a pop-up.
- Slider minimum at the leading edge, maximum at the trailing edge.
- iOS: switches only inside list rows; don't use a slider for volume. macOS also has checkboxes
  (which can be mixed), mini switches, and sliders with tick marks or circular form.
- **Misuse**: encoding state with color alone, using a switch where a checkbox is correct, a slider
  with no precise input alongside it.

## Progress indicators

- **When**: showing that work hasn't stalled and, where possible, how long remains.
- Determinate uses a bar or ring; indeterminate uses a spinner; macOS also has an indeterminate bar.
- Cancellable; when cancelling would lose work, offer pause and confirm with an alert.
- iOS refresh controls trigger on pull, stay hidden by default, and still refresh automatically;
  macOS prefers a spinner with no label.
- **Misuse**: jumping progress, switching between ring and bar, copy that says "loading".

## Sidebars

- **When**: leading-side navigation to sections or top-level collections.
- They occupy substantial space; when space is tight, use a tab bar instead.
- Content may extend under the sidebar; **hierarchy ≤2 levels**, anything deeper uses a split view;
  icons default to the accent color.
- iOS/iPadOS: start with a tab bar; `sidebarAdaptable` converts between the two. macOS: row height and
  glyph size in small/medium/large, collapsing automatically as the window narrows.
- **Misuse**: critical items at the bottom, forcing deep hierarchy in.

## Windows

- **When**: hosting views, supporting multiple windows and multitasking.
- visionOS: default 1280×720, opened roughly 2 m away at a visual width near 3 m; **minimum and
  maximum sizes are required**.
- macOS: a frame plus a body, in main / key / inactive states.
- When iPadOS is windowed, controls overlap the toolbar's leading edge, so buttons must move inward.
- **Misuse**: critical actions at the bottom of a window, hand-drawing the system chrome.

## Scrolling

- **When**: content exceeds the view bounds.
- Support system gestures and bounce; **show a sliver of content** to hint that it scrolls; **never
  nest scroll views in the same direction**.
- Paging is allowed: one page equals the view height or width, with overlap permitted; auto-scrolling
  stops once the content is "enough"; zoom needs min/max limits.
- iOS/iPadOS/macOS use a **scroll edge effect** to separate floating bars from content — prefer
  `automatic`, and only one per view.
- **Misuse**: adding an edge effect with no floating layer, two nested scrolls in the same direction.

## Search

- **When**: finding things within a content collection.
- Anatomy: search icon + clear + placeholder, optionally a scope bar (broad to narrow) and tokens.
- Search as the user types, offer suggestions, order results by relevance.
- iOS has three entry points: tab bar (focuses immediately when there's a landing page or button),
  toolbar (bottom preferred, otherwise pinned top), and inline. iPadOS/macOS put it in the toolbar's
  trailing edge or at the top of the sidebar.
- **Misuse**: vague placeholders, unsorted results.
