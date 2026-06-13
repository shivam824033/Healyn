# Handoff: Physio “Today” / Schedule — *Refined Indigo* redesign

## Overview
Restyle the physiotherapist's **Today / Schedule** screen
(`lib/features/physio/presentation/screens/physio_today_screen.dart`) to the
*Refined Indigo* direction: a gradient brand hero greeting, three floating
stat cards, a horizontal week strip, a restyled requests banner, and richer
appointment rows (time block + patient avatar + treatment line + status &
badges).

**This is a visual restyle only.** Keep all existing providers, navigation,
refresh, and data flow exactly as they are. Do **not** change anything outside
the presentation layer of this screen, and do not alter the design-token files.

## About the design files
`Physio Today — Redesigns.html` in this folder is a **design reference built in
HTML** — a prototype of the intended look, not code to copy. Your job is to
recreate **Variant 1 (“Refined Indigo”)** — the left-most phone — in Flutter
using the app's existing widgets and tokens. Ignore variants 2–4.

## Fidelity
**High-fidelity.** Colors, spacing, radii, and type below are exact and all map
to existing `Healyn*` tokens — reuse the tokens, do not hard-code new values.

---

## Existing building blocks to reuse (do not reinvent)
| Token / widget | Path |
| --- | --- |
| `HealynColors` (brandGradient, brandPrimary, brandPrimarySubtle, status*, text*, border*, surface*) | `lib/features/shared/design/colors.dart` |
| `HealynTypography` (display/h1/h2/h3/body/bodyStrong/caption/overline) | `lib/features/shared/design/typography.dart` |
| `HealynSpacing` (s1–s10, screenEdge) | `lib/features/shared/design/spacing.dart` |
| `HealynRadii` (sm/md/lg/xl) | `lib/features/shared/design/radii.dart` |
| `HealynElevation` (e1/e2) | `lib/features/shared/design/elevation.dart` |
| `AppointmentStatusChip` | `lib/features/appointments/presentation/widgets/appointment_status_chip.dart` |
| `_UnreadBadge` / `_PendingFilesBadge` | already private in `physio_today_screen.dart` — keep & reuse |
| Providers: `physioScheduleProvider`, `physioScheduleActivityProvider`, `calendarMarkedDaysProvider`, `physioRequestsProvider`, `scheduleDayProvider`, `calendarMonthProvider`, `patientsProvider` | unchanged |

---

## Screen spec — *Refined Indigo*

Replace the current `AppBar` + `MonthCalendar` + plain list with the structure
below. Wrap everything in the existing `Scaffold` → `SafeArea`, and keep the
`RefreshIndicator` + `schedule.when(loading/error/data)` logic intact around the
roster list. Suggest a `CustomScrollView`/`ListView` so the hero scrolls with
content (the current screen pins the calendar; Refined Indigo scrolls the whole
page).

### 1. Gradient hero header
- Full-bleed container, `HealynColors.brandGradient`, bottom corners rounded
  `Radius.circular(30)`, padding `EdgeInsets.fromLTRB(s5, s2, s5, s8)`
  (extra bottom padding so the stat cards can overlap it).
- **Row:** left column + right avatar.
  - Eyebrow: `“Good morning,”` — `HealynTypography.body` (≈13.5) at `white` 82% opacity, weight 500.
  - Name: the **signed-in physio's name** — `HealynTypography.h1` recolored `textInverse`, weight 800, single line (`overflow: ellipsis`). Source it from your current-account / profile provider (`current_account.dart`). If only an email is available, fall back to that.
  - Avatar: 44×44 circle, `white @ 18%` fill, `1.5px white @ 35%` border, physio's initials in `bodyStrong`/`textInverse`.
- **Date pill** below the row, `margin-top: s4`: rounded-full chip, `white @ 16%`
  fill, calendar icon + long date of `scheduleDayProvider`
  (reuse `formatDateLong` from `appointment_format.dart`), `caption`/600/white.

### 2. Floating stat cards (3-up)
- A `Row` of 3 equal cards pulled **up into the hero** with a negative top
  margin (`Transform.translate` y ≈ −34, or a `Stack`/overlap of ~44px),
  horizontal margin `s5`, gap `s3`.
- Each card: `surfaceBase`, `1px borderSubtle`, radius `HealynRadii.lg` (14),
  `HealynElevation.e2` (so they lift off the gradient), padding `s4`.
  - Icon tile 34×34, radius `md`, tinted background + matching icon:
    - **Today** → `brandPrimarySubtle` bg / `brandPrimary` icon (`Icons.event_available` / calendar-check)
    - **Requests** → `statusWarning @ 12%` bg / `statusWarning` icon (`Icons.inbox_outlined`)
    - **Notes due** → `statusSuccess @ 12%` bg / `statusSuccess` icon (`Icons.note_alt_outlined`)
  - Number: `HealynTypography.h1`/800 (≈22). Label: `caption`/`textMuted`.
- **Data mapping (important — use real values, don't invent):**
  - *Today* = length of the day's roster (`physioScheduleProvider` data count).
  - *Requests* = `physioRequestsProvider.length` (same source as the banner).
  - *Notes due* = **only if a provider exists** for outstanding treatment notes
    (see `treatment_notes` feature). **If there is no such count, drop the third
    card and make the row a 2-up**, or replace with another real metric (e.g.
    “Unread” from `physioScheduleActivityProvider`). Do **not** show a fabricated
    number.

### 3. Week strip (replaces the month grid for this screen)
- A `Row` of 7 equal day cells for the week containing `scheduleDayProvider`,
  horizontal padding `screenEdge`, top margin `s5`.
- Cell: column of weekday abbrev (`caption`/600/`textMuted`, uppercase),
  day number (`bodyStrong`), and a 5px marked-day dot (`brandPrimary`, shown
  only when that date ∈ `calendarMarkedDaysProvider`).
- **Selected day:** fill `HealynColors.brandGradient`, radius `lg`, soft brand
  shadow; weekday + number + dot all `textInverse`.
- Tapping a cell sets `scheduleDayProvider` (and `calendarMonthProvider` if it
  crosses a month), exactly like the current `selectDay`. Keep the existing
  full `MonthCalendar` reachable if you want (e.g. a “month” affordance), but the
  default Today view uses this compact strip.

> If you'd rather not drop the month grid, an acceptable alternative is to keep
> `MonthCalendar` but wrap it in a white card with the new hero above it. The
> week strip is the recommended look.

### 4. Requests banner (restyled)
- Render only when `physioRequestsProvider.length > 0` (unchanged rule).
- Card: `brandPrimarySubtle` fill, radius `lg`, padding `s3 s4`, margin
  `s4 0`. White 34×34 icon tile (radius `md`) with `Icons.inbox_outlined` in
  `brandPrimary`; title `“N new booking requests”` (`bodyStrong`/`brandPrimary`),
  subtitle `“Tap to review & confirm”` (`caption`/`brandPrimary` @ 80%);
  trailing `Icons.chevron_right` in `brandPrimary`. Taps push `/physio/requests`.

### 5. Section header
- Row: `“Today's schedule”` (`HealynTypography.h2`/700, ≈16–20) + a rounded-full
  count chip `“N appts”` (`caption`/600/`brandPrimary` on `brandPrimarySubtle`).
  Padding `s5 s1 s3`.

### 6. Appointment row (the new `_ScheduleTile`)
Restyle the existing `_ScheduleTile`. Keep its `InkWell` → `context.push(
'/physio/appointments/{id}', extra: appointment)` and all badge logic.
- Container: `surfaceBase`, `1px borderSubtle`, radius `HealynRadii.lg` (18 ok),
  `HealynElevation.e1`, padding `s3`, vertical gap `s3` between rows.
- **Leading time block:** 54px-wide column, `surfaceAlt` fill, radius `md`,
  centered. Big start time `bodyStrong`/800 (≈15), `AM/PM` overline-ish
  (`caption`/700/`textMuted`), duration line (`caption`/`textMuted`, e.g.
  “45m”). Derive from `scheduledAt`/`scheduledEndAt` via the existing
  `formatTimeOfDay` (reuse `_timeRange` logic; show the **start** prominently).
- **Body:** small 30×30 initials avatar (tonal fill — pick a deterministic color
  per patient, e.g. hash patientId into a small brand-adjacent palette) + patient
  name (`bodyStrong`); a **treatment / reason** line under it (`body`/`textSecondary`).
  - ⚠️ **Treatment line:** the mock text (“Post-op knee rehab”, etc.) is invented.
    Use a real field only if `Appointment` (or a linked treatment note) has a
    reason/title. If no such field exists, **omit the line** and let the row read
    time + name + status — do not fabricate a diagnosis.
  - Badge row: `AppointmentStatusChip(status:)` + the existing `_UnreadBadge`
    (when `activity.hasUnread`) + `_PendingFilesBadge` (when
    `activity.hasPendingFiles`), in a `Wrap` with `s2` spacing — unchanged.
- Trailing `Icons.chevron_right` in `textMuted`, vertically centered.

### 7. Empty & error states
Keep `_EmptyDay` and the `ErrorBanner` path. Optionally restyle `_EmptyDay`'s
icon tile to sit on a `surfaceAlt` rounded square for consistency, but content &
copy stay.

---

## Interactions & behavior (all already exist — preserve)
- Pull-to-refresh invalidates schedule, activity, marked days, requests.
- App resumes / lifecycle handling: unchanged.
- Day tap → `scheduleDayProvider`; month cross → `calendarMonthProvider`.
- App-bar “Upcoming” action (`/physio/upcoming`) — fold into the hero (e.g. a
  small `Icons.upcoming_outlined` button top-right of the hero) **or** keep a
  minimal `AppBar`. Don't lose the route.
- Press feedback on cards via `InkWell` (radius-matched), as today.

## Design tokens (exact — all already defined)
- Brand: `#3B4AA0` → `#2E3A82` gradient; subtle `#ECEDF9`.
- Status: success `#16A34A`, warning `#D97706`, info `#2563EB`, danger `#DC2626`.
- Text: primary `#0F172A`, secondary `#475569`, muted `#94A3B8`, inverse `#FFF`.
- Surface `#FFFFFF` / alt `#F7F8FA`; border `#E5E7EB`.
- Spacing 4-px scale (`HealynSpacing`); radii sm6/md10/lg14/xl20; elevation e1/e2.

## Assets
No image assets. Icons are Material (`Icons.*`) — the HTML used Font Awesome
equivalents; map to the closest Material glyphs (suggestions given above).
Avatars are initials on a tonal fill — no external images.

## Files in this bundle
- `Physio Today — Redesigns.html` — the HTML reference (implement **Variant 1**).
- `README.md` — this document.
