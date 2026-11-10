# Patterns and input: from onboarding to keyboard

Source: HIG (captured 2026-11-10). Thresholds and numbers as stated in the original.

## Onboarding

- **Use**: only when genuinely needed, and after launch.
- **Do**: make it interactive; split hints by context; keep required flows short, skippable, and never
  repeat them; supply defaults and defer non-essential setup; fold permission requests in and explain
  why; let people experience the product before asking for a rating.
- **Don't**: teach the system (that's the system's job), or open with a license agreement.

## Loading

- Ideal: finish before the person notices.
- Show an indicator only when there will genuinely be a wait — a progress bar that flashes for an
  instant is worse than none.
- Show placeholder content first; load in parallel in the background; warn on long waits.
- Known duration → determinate; unknown → indeterminate.
- **Don't**: leave a blank screen waiting; never let a spinner become the normal state on watchOS.

## Feedback

- **Use**: to report status, success or failure, warnings, and corrections.
- Match intensity to importance: status messages stay passive; interrupt only when data may be lost.
- Combine **color + text + sound + haptics**.
- Reserve confirmation for important actions.
- **Don't**: overuse alerts, warn about expected deletions, or say "can't" without a reason.

## Search

- Give it a primary position (toolbar or its own tab) if search matters.
- One entry point finds everything; make sections obvious and allow local filters.
- Use placeholder text or a scope bar to show what is being searched.
- Offer recent searches and suggestions; treat history as private and make it clearable.
- Integrate with Spotlight (system-wide reach).
- **Don't**: leave the scope vague or leak history.

## Settings

- General, rarely-changed options go in Settings; task-level options appear inline.
- Defaults should cover the majority; fewer settings is better.
- `Command-,` opens settings (Esc in games).
- Detect automatically instead of asking.
- **Don't**: duplicate system-level settings, move task options into Settings, or put Settings in the
  toolbar on macOS.

## Data entry

- If the system can supply it, don't ask.
- Placeholder hints explain the expected format; prefill sensible defaults.
- Sensitive fields use secure input; prefer pickers over keyboards.
- Support drag and drop, and pasting; validate as the user types.
- Disable "Next" until required fields are complete.
- **Don't**: prefill passwords.

## Modality

- **Use**: to confirm critical information, undo a just-performed action, for narrowly scoped tasks,
  and for immersive experiences.
- Keep it short and linear; dismissal follows the platform (top button or swipe down on iOS).
- The title states the task directly.
- Confirm before discarding content.
- **Don't**: put a modal inside a modal, or stack multiple modals or alerts.

## Drag and drop

- Support it app-wide where possible.
- **Same container = move; across containers/apps = copy.**
- Show a translucent image while dragging.
- Highlight only valid drop targets; show `circle.slash` on invalid ones.
- Support multi-item drags; always provide a menu as an alternative path; confirm before
  irreversible drops.
- Offer multiple fidelity versions ordered by fidelity; holding Option = copy; keep the item selected
  after dropping.
- **Don't**: make drag and drop the only way to do something important.

## Notifications

- Get authorization before sending.
- Four interruption levels: **Passive / Active (default) / Time Sensitive / Critical**.
- Time Sensitive: only for something happening now or **within an hour**; it can pierce Focus and
  summaries but not silent mode.
- Critical: pierces silent mode and Focus, requires special authorization, extraordinarily rare.
- Marketing notifications require explicit consent and **must never be Time Sensitive**.
- Notification settings must be editable in-app.
- **Don't**: exaggerate urgency.

## Help, hints, and undo

- Explain in place, relevant to the current task, dismissible at any time.
- Use the platform's verbs (tap / click).
- Hints are **1–2 sentences**, actionable, and shown by rule (e.g. once every 24 hours); **anything
  needing more than 3 steps should not be a hint**.
- Tooltips are short (a line or two), start with a verb, and don't repeat the control name.
- Undo must be predictable ("Undo Typing"), show its result, and support repeated invocations.
- **Don't**: use hints to teach multi-step features.

## Charts

- **Use**: to highlight a conclusion, not to dump every data point.
- Keep it simple and expandable on demand; choose familiar chart types; include a title and
  annotations.
- Multiple charts share one type and one palette; provide accessibility labels.
- **Don't**: cram in data points.

## Gestures

- Standard gestures behave consistently across platforms; **don't give a familiar gesture a novel
  meaning, and don't invent a new gesture for something standard**.
- Custom gestures must be discoverable, easy to perform, non-conflicting, and never the only path.
- When unavailable, explain why.
- visionOS: indirect gestures (look + pinch) beat direct touch.
- watchOS: double-tap scrolls or advances; don't assign a primary action to list pages.
- **Don't**: conflict with system gestures.

## Keyboard

- Support Full Keyboard Access.
- Don't redefine standard shortcuts; add custom ones only for high-frequency actions.
- Command first, Shift as a secondary, Option sparingly, avoid Control; modifier order is
  **Control-Option-Shift-Command**.
- **Don't**: hijack standard shortcuts.

## Pointer (mouse / trackpad)

- Respond consistently; don't alter system gestures.
- iPadOS has highlight / lift / hover states.
- Hit-area expansion: **12 pt for bordered controls, 24 pt for borderless ones**.
- **Don't**: add decorative pointer effects.

## Apple Pencil and remotes

- Pencil: **ink appears as the pencil touches down**, not when it lifts.
- Pressure, tilt, and barrel roll can modulate strokes; hover is preview only (use the middle value)
  and **must not trigger actions**.
- Scribble works everywhere except password fields; while writing, don't autocomplete, scroll, or move
  the field.
- Remotes: follow standard gestures and focus direction — press = confirm, tap = navigate; guard
  against accidental input during playback.
- **Don't**: trigger actions on hover.
