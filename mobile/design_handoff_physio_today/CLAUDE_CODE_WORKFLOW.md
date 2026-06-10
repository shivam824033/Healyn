# Claude Code Workflow — roll Refined Indigo across the whole app

Run these from your Flutter project root, **in order**. The big idea: build the
shared widget kit **first** (Phase 1), then refactor screens to compose it
(Phase 2). That's what keeps 28 screens consistent. Do **not** restyle screens
before the kit exists.

Put `DESIGN_LANGUAGE.md`, `README.md`, and `Physio Today — Redesigns.html`
(this folder) into your repo so Claude Code can read them.

---

## Phase 0 — Orientation (one prompt, no code)
```
Read design_handoff_physio_today/DESIGN_LANGUAGE.md and README.md, and skim
lib/features/shared/design/ and lib/features/shared/widgets/. Then give me:
1) a confirmation of the existing tokens/widgets you'll reuse,
2) the list of new shared widgets you'll create (names + files) per the kit,
3) any data sources you're unsure exist (so I can confirm before you build).
Don't write code yet.
```
Answer any data questions it raises before continuing.

---

## Phase 1 — Build the shared widget kit (the foundation)
```
Implement the Refined Indigo shared widget kit described in section 2 of
DESIGN_LANGUAGE.md, under lib/features/shared/widgets/. Build ALL of:
HealynHero, HealynStatCard + HealynStatRow, HealynTonalIcon, HealynWeekStrip,
HealynListRow, HealynTimeBlock, HealynAvatar, HealynInfoBanner,
HealynSectionHeader.

Constraints:
- Use ONLY Healyn* tokens (colors/spacing/radii/elevation/typography). No raw
  hex or magic numbers. Don't modify the token files.
- Pure presentation widgets: no providers, no business logic, no navigation
  baked in (take callbacks like onTap/onSelect).
- Each widget gets a short doc comment and sensible defaults.
- Make them robust to long text (ellipsis) and large text scale.

Then create a throwaway gallery screen (lib/dev/refined_indigo_gallery.dart,
not wired into routes) that renders one of each widget so I can eyeball them.
Run `flutter analyze` and report.
```
Review the gallery. Iterate on the kit until it looks right — **fixing the kit
once fixes every screen later.**

---

## Phase 2 — Refactor the pilot screen (prove the kit)
```
Refactor lib/features/physio/presentation/screens/physio_today_screen.dart to
"Refined Indigo" by composing the shared kit, following README.md (Variant 1)
and the Archetype A recipe in DESIGN_LANGUAGE.md.

Visual only — keep every provider, route, refresh, lifecycle and empty/error
path exactly as-is. Use real data sources only; if a metric/field doesn't
exist, follow the README fallback (omit, don't invent). Show me your data
mapping before writing, then implement and run `flutter analyze`.
```
This is the reference implementation. Once you're happy, the rest follow the
same template.

---

## Phase 3 — Roll out screen-by-screen (repeat the template)
Go in **archetype batches** (same recipe = same muscle memory, fewer surprises).
Do one batch, review, commit, then the next. Per-screen template:

```
Refactor <path/to/xxx_screen.dart> to Refined Indigo.
Archetype: <A/B/C/D/E> (see DESIGN_LANGUAGE.md section 4).
Compose the shared kit widgets; match the kit/tokens; reuse the pilot
(physio_today_screen.dart) as the reference for patterns.

Rules: visual only — preserve all providers, routes, refresh, validation, and
empty/error/loading states. Tokens only, no raw values. Real data only; omit
anything not backed by the model/providers. Run `flutter analyze` when done and
show me a before/after of the build() structure.
```

Suggested batch order (low-risk → high-touch):
1. **B — lists:** physio_patients, appointments, physio_upcoming,
   physio_requests, family, unread_discussions, treatment_notes_timeline.
2. **A — dashboards:** physio_today (done in Phase 2), home.
3. **C — details:** appointment_detail, physio_appointment_detail,
   physio_patient_detail, profile, physio_profile, physio_treatment_note,
   discussion.
4. **D — forms:** book_appointment, reschedule_appointment, patient_form,
   availability_rule_form, availability_blackout_form, notification_preferences,
   physio_availability.
5. **E/D — auth:** splash, login, register_start, register_verify,
   password_reset_start, password_reset_complete.

---

## Phase 4 — Consistency sweep (one prompt at the end)
```
Audit all refactored screens for Refined Indigo consistency:
- any raw hex / magic numbers that should be Healyn* tokens,
- any one-off widget that duplicates a shared-kit widget (replace it),
- inconsistent spacing/radii/elevation vs the kit,
- overflow at 360-dp width and at the largest text scale.
List findings as a checklist and fix them. Run `flutter analyze`.
```

---

## Working tips
- **Commit after every batch** (or every screen) so you can diff and revert
  cleanly. Ask Claude Code to keep changes scoped to the named files.
- If a screen reveals a missing pattern, **add it to the kit**, don't inline it —
  then reuse. Update DESIGN_LANGUAGE.md section 2 so the kit stays the source of
  truth.
- Keep `flutter analyze` green between steps; don't batch up errors.
- For anything ambiguous (a metric, a field, a route), tell Claude Code to ask
  rather than guess — the "show me your data mapping first" line in each prompt
  is what forces that.
- Optional safety net: gate the new look behind a simple flag or keep the old
  screen as `*_legacy.dart` during rollout, so you can A/B and ship gradually.

## What "good" looks like at the end
Every screen reads as one app: same hero treatment, same soft rows, same tonal
icons, same spacing rhythm — because they all draw from one kit, on your
existing indigo tokens, with no behavior changed.
