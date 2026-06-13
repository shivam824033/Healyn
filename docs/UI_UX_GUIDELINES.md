# UI_UX_GUIDELINES.md

> The visual and interaction language of Healyn.
> The goal: a calm, premium, **healthcare-grade** product. No carnival colors, no busy gradients, no clutter.

---

## 1. Design Principles

1. **Calm over crowded.** Every screen has one primary action. Secondary actions are visible but de-emphasized.
2. **Content first.** Whitespace is structure, not waste. Cards breathe.
3. **Predictable, not clever.** Patients are anxious. The UI must be boring in the best way.
4. **One brand color, used sparingly.** Color earns its presence by carrying meaning (primary action, status).
5. **Typography does heavy lifting.** Hierarchy comes from type scale and weight, not from boxes and borders.
6. **Animation serves the user.** Motion confirms cause and effect; it never delights for its own sake.
7. **Accessibility is a baseline, not a feature.** WCAG AA is the floor.

---

## 2. Color System

### 2.1 Core Palette

| Token | Hex | Use |
|---|---|---|
| `color.brand.primary` | `#3B4AA0` | Primary actions, active states, links |
| `color.brand.primary_hover` | `#2E3A82` | Pressed primary buttons |
| `color.brand.primary_subtle` | `#ECEDF9` | Selected backgrounds, tonal containers |
| `color.surface.base` | `#FFFFFF` | App background |
| `color.surface.alt` | `#F7F8FA` | Cards, secondary surfaces |
| `color.surface.elevated` | `#FFFFFF` | Floating cards, sheets (with shadow) |
| `color.border.subtle` | `#E5E7EB` | Dividers, default borders |
| `color.border.strong` | `#9CA3AF` | Focus rings (on light bg) |
| `color.text.primary` | `#0F172A` | Body text |
| `color.text.secondary` | `#475569` | Labels, captions |
| `color.text.muted` | `#94A3B8` | Disabled, placeholders |
| `color.text.inverse` | `#FFFFFF` | Text on `brand.primary` |

### 2.2 Semantic / Status

| Token | Hex | Use |
|---|---|---|
| `color.status.success` | `#16A34A` | Confirmed appointment, success toast |
| `color.status.warning` | `#D97706` | Pending state, low-urgency advisory |
| `color.status.danger` | `#DC2626` | Cancellation, destructive action |
| `color.status.info` | `#2563EB` | Informational pill (rare) |

Status colors are never used for buttons unless the button's action is exactly that status (e.g., a `danger` "Cancel appointment" button).

### 2.3 Dark Mode (Phase 2)

Tokens above are defined for light mode. Dark mode tokens (`color.surface.base = #0B1220`, etc.) are scoped out of Phase 1; the system is built token-first so dark mode is a configuration swap, not a re-skin.

### 2.4 Contrast Requirements

| Pair | Minimum Ratio |
|---|---|
| Body text on surface | 7:1 (AAA) |
| Secondary text on surface | 4.5:1 (AA) |
| Button text on button | 4.5:1 |
| Focus ring against adjacent | 3:1 |

All tokens above meet these requirements. New tokens must be verified.

---

## 3. Typography

### 3.1 Font Family

- **Inter** is the primary family.
- System fallback: `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`.
- Inter is bundled in the Flutter app; no runtime fetch.

### 3.2 Type Scale

| Token | Size | Line height | Weight | Use |
|---|---|---|---|---|
| `type.display` | 32 | 40 | 700 | Onboarding, marketing-style headers |
| `type.h1` | 24 | 32 | 700 | Screen titles |
| `type.h2` | 20 | 28 | 600 | Section headers |
| `type.h3` | 17 | 24 | 600 | Card titles |
| `type.body` | 15 | 22 | 400 | Body copy |
| `type.body_strong` | 15 | 22 | 600 | Emphasis in body |
| `type.caption` | 13 | 18 | 400 | Captions, helper text |
| `type.overline` | 11 | 16 | 600, 1.2 letter-spacing | Status pills, tab labels |

Numerals are **tabular** for any column of numbers (counts, durations, times).

### 3.3 Rules

- Body copy is `15/22`. Anything smaller is informational; never primary content.
- Never set body text below `13`.
- Line lengths are capped at ~75 characters on tablets and wider.
- All-caps is reserved for `overline`. No screaming headlines.

---

## 4. Spacing & Layout

### 4.1 Spacing Scale

A 4-px base scale:

| Token | Value |
|---|---|
| `space.0` | 0 |
| `space.1` | 4 |
| `space.2` | 8 |
| `space.3` | 12 |
| `space.4` | 16 |
| `space.5` | 20 |
| `space.6` | 24 |
| `space.7` | 32 |
| `space.8` | 40 |
| `space.9` | 48 |
| `space.10` | 64 |

### 4.2 Layout Defaults

- Screen edge padding: `space.4` (16 px) on phone, `space.6` (24 px) on tablet.
- Card internal padding: `space.4`.
- Vertical rhythm between siblings: `space.3` (12) within a card, `space.6` (24) between sections.
- Forms: labels above inputs, `space.2` (8 px) gap; field gap `space.4`.

### 4.3 Radii

| Token | Value | Use |
|---|---|---|
| `radius.sm` | 6 | Pills, badges |
| `radius.md` | 10 | Inputs, small buttons |
| `radius.lg` | 14 | Cards, primary buttons |
| `radius.xl` | 20 | Sheets, modals |
| `radius.full` | 9999 | Avatars |

Avoid mixing radii on the same surface. A card with a radius-`lg` outer should have radius-`md` inner controls — never the reverse.

### 4.4 Elevation

| Token | Use | Shadow (light mode) |
|---|---|---|
| `elev.0` | Flat surface | none |
| `elev.1` | Card | `0 1px 2px rgba(15,23,42,0.04), 0 2px 8px rgba(15,23,42,0.06)` |
| `elev.2` | Hovered card / sheet / header | `0 2px 6px rgba(15,23,42,0.05), 0 8px 24px rgba(15,23,42,0.08)` |
| `elev.3` | Modal | `0 12px 32px rgba(15,23,42,0.12)` |

Never use elevation as the **only** affordance for interactivity; pair with cursor / focus / press state.

---

## 5. Component Patterns

### 5.1 Buttons

| Variant | Use | Visual |
|---|---|---|
| Primary | The one main action per screen | Filled `brand.primary`, white text, radius-lg |
| Secondary | Alternative confirm actions | Border `border.subtle`, text `text.primary` |
| Tertiary / Text | Inline links, low-emphasis | No border, `brand.primary` text |
| Destructive | Cancel, delete | Border or fill `status.danger`, used sparingly |

Min tap target: **44 × 44 px**. Buttons have at least `space.4` horizontal padding and `space.3` vertical.

### 5.2 Inputs

- 48 px tall minimum.
- Label above input. Helper text below.
- Error state: red border + caption-sized error message below.
- No placeholder-as-label.
- Show/hide for password fields is required.

### 5.3 Cards

- Background `surface.alt` or `surface.elevated`.
- Radius `radius.lg`.
- Elevation `elev.1` default; `elev.2` when tappable + pressed.
- Internal padding `space.4`.
- Title line uses `type.h3`; metadata uses `type.caption text.secondary`.

### 5.4 Status Pills

- 24 px tall, `radius.sm`.
- `type.overline` weight.
- One per row max in a list view.

| Status | Background | Text |
|---|---|---|
| `REQUESTED` | `#FFF3E0` | `#D97706` |
| `CONFIRMED` | `#ECEDF9` | `#2E3A82` |
| `IN_PROGRESS` | `#E0F2FE` | `#2563EB` |
| `COMPLETED` | `#E7F8EE` | `#15803D` |
| `CANCELLED` | `#FEE2E2` | `#B91C1C` |
| `NO_SHOW` | `#F3F4F6` | `#475569` |
| `RESCHEDULED` | `#EDE9FE` | `#6D28D9` |

### 5.5 Empty States

Every list view defines an explicit empty state: small illustration or icon, one-sentence headline, one button to the next action. Never an empty white screen.

### 5.6 Loading States

- Skeletons over spinners for lists and cards.
- A single global spinner at the top of the screen for full-screen loads.
- No spinner blocks tap targets that the user could already tap.

### 5.7 Error States

- Inline (field-level) for form errors.
- Banner at top of screen for system errors with a "Retry" affordance.
- Full-page error with illustration for total failures (no network).

---

## 6. Iconography

- Line icons, 1.5 px stroke, 24 × 24 px on a 24 box.
- Source: **Lucide** (license-clean, comprehensive).
- One stroke weight across the app.
- Icon-only buttons require an accessibility label.

---

## 7. Motion

### 7.1 Durations

| Token | Value | Use |
|---|---|---|
| `motion.fast` | 120 ms | Hover, tap response |
| `motion.standard` | 220 ms | Navigation, sheets, modals |
| `motion.slow` | 320 ms | Onboarding hero, large reveals |

### 7.2 Easings

- Default: `Curves.easeOutCubic` (Flutter) / `cubic-bezier(0.22, 1, 0.36, 1)`.
- Avoid bouncy / elastic curves. They feel toy-like in a healthcare context.

### 7.3 Rules

- Motion confirms cause and effect (a tap, a navigation).
- Reduce motion: respect OS-level "reduce motion" setting; replace transitions with fades.
- Never animate purely for decoration on a clinical screen.

---

## 8. Navigation

### 8.1 Top-Level Structure (Patient)

```
Bottom nav:
  Home    ·    Appointments    ·    Family    ·    Profile
```

- 4 tabs maximum. A fifth would dilute focus.
- Each tab has its own back stack.
- Deep links resolve into the correct tab + stack.

### 8.2 Top-Level Structure (Physiotherapist)

```
Bottom nav:
  Today    ·    Schedule    ·    Patients    ·    Profile
```

### 8.3 Patterns

- Title in the AppBar matches the screen.
- Back affordance always on the left.
- Primary action (FAB or top-right) on screens that have one. Otherwise none.
- Modal sheets for transient actions (book, attach, edit profile). Full screens for primary flows.

---

## 9. Forms

- Validate **on blur** for individual fields; validate the whole form on submit.
- Disable the submit button only when the form is clearly invalid; otherwise leave it enabled and surface the error on submit.
- Single column on phone; never side-by-side fields below 600 px width.
- Phone number input uses a country selector + E.164 storage.
- Date pickers use the native OS picker.

---

## 10. Accessibility

| Concern | Standard |
|---|---|
| Color contrast | WCAG AA minimum, AAA for body text |
| Tap target | ≥ 44 × 44 px |
| Focus | Visible focus ring (3:1 contrast) on every interactive element |
| Screen reader | All images have `semanticsLabel`; icon-only buttons have `tooltip` |
| Dynamic type | Respect OS text-size scaling; layouts must not clip up to 1.3× |
| Reduce motion | Respect OS setting; substitute fades |
| Color independence | Never convey state by color alone (pair with icon or label) |
| Form labels | Every input has a visible label or `semanticsLabel` |
| Errors | Announced via `LiveRegion` |

---

## 11. Voice & Microcopy

- Plain, calm, human. Read like a careful clinician would speak.
- Buttons are verbs in present tense: "Book appointment", "Save changes".
- Avoid jargon and exclamation marks.
- Errors describe what happened and what to try, in that order. Never blame the user.

Examples:

| Bad | Good |
|---|---|
| "Error! Booking failed." | "That slot was just booked by someone else. Try the next available time." |
| "Are you sure???" | "Cancel this appointment? You can rebook anytime." |
| "Submit" | "Book appointment" |

---

## 12. Implementation Notes (Flutter / Riverpod)

- Design tokens live in `lib/features/shared/design/`:
  - `colors.dart`, `typography.dart`, `spacing.dart`, `radii.dart`, `elevation.dart`, `motion.dart`.
- A `HealynTheme` extends Flutter's `ThemeData` from these tokens.
- Components are in `lib/features/shared/widgets/`. No feature folder defines its own button.
- A `golden_test` per component locks visuals; Renovate updates do not silently change UI.
- Theming is provider-scoped so dark mode (Phase 2) toggles without a reload.

---

## 13. Anti-Patterns

- **Do not** use heavy gradients, glassmorphism, neon, or aurora effects.
- **Do not** ship more than the single `brand.primary` for accent. Status colors are not brand colors.
- **Do not** put hover-only interactions on mobile (no info revealed only on long press without an alternative).
- **Do not** rely on time-of-day-changing color schemes (gimmicky).
- **Do not** use third-party UI kits that conflict with the token system.

---

## 14. Related Documents

- [PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md) — the calm-and-premium product vision
- [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md) — Flutter linting, golden tests
