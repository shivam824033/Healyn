# Refined Indigo — Design Language (project-wide)

The single source of truth for applying the *Refined Indigo* look to **every**
screen in the Healyn app. Claude Code should read this once, build the shared
widget kit in **Phase 1**, then refactor screens to use it in **Phase 2**
(see `CLAUDE_CODE_WORKFLOW.md`).

> Golden rule: **consistency comes from shared widgets, not from restyling each
> screen by hand.** If two screens need the same element, it must be the *same
> widget*, not two look-alikes.

---

## 0. Non-negotiables
- **Visual layer only.** Never change providers, repositories, models, routes,
  or business logic. Restyle presentation widgets; keep behavior identical.
- **Reuse tokens.** Every color/space/radius/shadow comes from `Healyn*` tokens
  (`lib/features/shared/design/`). No raw hex, no magic numbers. Do not edit the
  token files.
- **Never invent data.** If a field/metric isn't in the model or a provider,
  omit that UI element — don't fabricate diagnoses, counts, or names.
- **One brand color, used sparingly** (per the existing UI guidelines). Indigo
  is for emphasis: hero, selected state, primary actions, key counts. Bodies of
  screens stay calm white/`surfaceAlt`.

---

## 1. The visual signature (what makes a screen "Refined Indigo")
1. **Gradient hero header** at the top of primary tab screens — `brandGradient`,
   bottom corners rounded 30, white text, optional trailing avatar/action.
2. **Floating cards that overlap the hero** — white, `lg` radius, `e2` shadow,
   pulled up ~34–44px into the gradient. Used for stat rows and key summaries.
3. **Tonal icon tiles** — 34×34, `md` radius, a 12%-tint background of a status/
   brand hue with the matching icon. The recurring motif across stats, banners,
   list leading slots.
4. **Soft list rows** — white, `1px borderSubtle`, `lg` radius, `e1` shadow,
   `InkWell` press, trailing chevron. A leading element (time block / avatar /
   icon tile) + title + subtitle + a `Wrap` of chips/badges.
5. **Pill chips & badges** — `sm` radius status chips (reuse
   `AppointmentStatusChip`); rounded-full count badges on `brandPrimarySubtle`.
6. **Section headers** — `h2`/700 title + optional rounded-full count chip.
7. **Generous whitespace** — `screenEdge` gutters, `s3` between rows, `s5–s6`
   between sections. Hierarchy from type & space, not borders.

A screen doesn't need *all* of these — pick what fits its job. A form screen
might only use the hero + section headers + styled fields; a list screen uses
hero + list rows.

---

## 2. The shared widget kit (build these in Phase 1)
Create under `lib/features/shared/widgets/` (extend, don't duplicate, the
existing `app_bar.dart`, `section_card.dart`, `card_header.dart`,
`nav_card.dart`, `primary_button.dart`, `app_text_field.dart`,
`error_banner.dart`).

| New widget | File | Purpose | Key params |
| --- | --- | --- | --- |
| `HealynHero` | `healyn_hero.dart` | Gradient header: eyebrow + title + optional subtitle/date pill + trailing slot. Bottom radius 30, `brandGradient`, padding `s5/s2/s5/s8`. | `eyebrow?`, `title`, `subtitle?`, `trailing?`, `bottomOverlap` (extra pad so cards can overlap) |
| `HealynStatCard` + `HealynStatRow` | `healyn_stat_card.dart` | The floating tonal-tile stat card and an equal-width row of them. `surfaceBase`, `lg`, `e2`. | `icon`, `tint`, `value`, `label`; row takes `List<HealynStatCard>` + negative top offset |
| `HealynTonalIcon` | `healyn_tonal_icon.dart` | 34×34 `md` tile, 12%-tint bg + colored icon. Reused everywhere. | `icon`, `color`, `size` |
| `HealynWeekStrip` | `healyn_week_strip.dart` | 7-day horizontal selector, gradient selected cell, marked-day dots. | `weekOf`, `selected`, `markedDays`, `onSelect` |
| `HealynListRow` | `healyn_list_row.dart` | The soft card row: leading + title + subtitle? + trailing chevron + optional `footer` (chip/badge Wrap). `e1`, `lg`, `InkWell`. | `leading`, `title`, `subtitle?`, `footer?`, `onTap` |
| `HealynTimeBlock` | `healyn_time_block.dart` | 54px leading time column (start time + AM/PM + duration) for appointment rows. | `start`, `end?` |
| `HealynAvatar` | `healyn_avatar.dart` | Initials on a deterministic tonal fill (hash id → small brand-adjacent palette). | `name`/`seed`, `size` |
| `HealynInfoBanner` | `healyn_info_banner.dart` | The `brandPrimarySubtle` tappable banner (tonal icon + title + subtitle + chevron). Generalizes the requests banner. | `icon`, `title`, `subtitle?`, `onTap`, `tone` (brand/warning/…) |
| `HealynSectionHeader` | `healyn_section_header.dart` | `h2` title + optional count chip. | `title`, `countLabel?`, `trailing?` |
| `FieldLabel` | `field_label.dart` | The label above a form control — `caption`/600, matching `app_text_field`'s internal label. Use it for the controls `AppTextField` can't host (dropdowns, picker-backed fields) so every field on a form reads the same. | `text` |

Once these exist, "make a screen Refined Indigo" becomes "compose it from these
widgets," which is fast and automatically consistent.

---

## 3. Token cheat-sheet (all already defined)
- **Gradient:** `HealynColors.brandGradient` (`#3B4AA0` → `#2E3A82`).
- **Brand:** primary `#3B4AA0`, hover `#2E3A82`, subtle `#ECEDF9`.
- **Status:** success `#16A34A`, warning `#D97706`, info `#2563EB`, danger `#DC2626`.
- **Text:** primary `#0F172A`, secondary `#475569`, muted `#94A3B8`, inverse `#FFF`.
- **Surface:** base `#FFFFFF`, alt `#F7F8FA`; **border** subtle `#E5E7EB`.
- **Spacing:** `HealynSpacing` 4-px scale; screen gutter = `screenEdge` (16).
- **Radii:** sm 6 (chips), md 10 (tiles/inputs), lg 14 (cards), xl 20 (sheets).
- **Elevation:** `e1` resting cards, `e2` floating/hovered, `e3` modals.
- **Type:** `display/h1/h2/h3/body/bodyStrong/caption/overline` — hierarchy from
  type, never from boxes.

---

## 4. Per-archetype recipes
Most screens fall into one of these. Apply the matching recipe.

### A. Primary tab / dashboard (e.g. `physio_today`, patient `home`)
Hero (greeting + date) → floating `HealynStatRow` → optional `HealynWeekStrip` →
`HealynInfoBanner` (when relevant) → `HealynSectionHeader` → list of
`HealynListRow`. Keep refresh/empty/error states.

### B. List / index (e.g. `physio_patients`, `appointments`, `family`,
`unread_discussions`, `treatment_notes_timeline`, `physio_upcoming`,
`physio_requests`)
Compact hero **or** styled `HealynAppBar` → optional filter/segment row →
`ListView.separated` of `HealynListRow` (leading `HealynAvatar` or
`HealynTonalIcon`). Preserve empty/error/refresh.

### C. Detail (e.g. `appointment_detail`, `physio_appointment_detail`,
`physio_patient_detail`, `physio_treatment_note`, `discussion`)
Hero or app bar with the subject's name/avatar → stacked `SectionCard`s with
`HealynSectionHeader` labels → action buttons via `primary_button`. Keep all
actions/handlers.

### D. Form (e.g. `book_appointment`, `reschedule_appointment`,
`patient_form`, `availability_*_form`, `notification_preferences`,
`physio_availability`, auth `login/register/password_reset`)
Styled `HealynAppBar` (forms usually don't need a gradient hero) → grouped
fields in `SectionCard`s with `HealynSectionHeader` → `app_text_field` styling
unchanged in behavior, refreshed visuals only → sticky `primary_button` CTA.
Keep all validation logic.

### E. Splash / auth entry (`splash_screen`, `login_screen`)
A good place for a **full** `brandGradient` background with centered logo/wordmark
and white form card floating on it (`e2`). High brand moment.

---

## 5. Screen inventory (28 screens → archetype)
| Screen | Archetype |
| --- | --- |
| physio/physio_today | A |
| home/home (patient) | A |
| physio/physio_patients · patients/family | B |
| appointments/appointments · physio/physio_upcoming · physio/physio_requests | B |
| discussion/unread_discussions · treatment_notes/treatment_notes_timeline | B |
| appointments/appointment_detail · physio/physio_appointment_detail | C |
| physio/physio_patient_detail · patients/profile · physio/physio_profile | C |
| physio/physio_treatment_note · discussion/discussion | C |
| appointments/book_appointment · appointments/reschedule_appointment | D |
| patients/patient_form · availability/availability_rule_form · availability/availability_blackout_form | D |
| notifications/notification_preferences · physio/physio_availability | D |
| auth/login · auth/register_start · auth/register_verify | D/E |
| auth/password_reset_start · auth/password_reset_complete | D |
| auth/splash | E |

---

## 6. Definition of done (per screen)
- Composed from the shared kit; no bespoke one-off styling that duplicates a kit
  widget.
- All `Healyn*` tokens, zero raw hex/magic numbers.
- Behavior, routes, providers, refresh, empty/error states unchanged.
- `flutter analyze` clean; no overflow at 360-dp width and at large text scale.
