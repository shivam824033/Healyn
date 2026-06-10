import 'package:flutter/material.dart';

import '../features/shared/design/colors.dart';
import '../features/shared/design/spacing.dart';
import '../features/shared/design/typography.dart';
import '../features/shared/widgets/healyn_avatar.dart';
import '../features/shared/widgets/healyn_hero.dart';
import '../features/shared/widgets/healyn_info_banner.dart';
import '../features/shared/widgets/healyn_list_row.dart';
import '../features/shared/widgets/healyn_section_header.dart';
import '../features/shared/widgets/healyn_stat_card.dart';
import '../features/shared/widgets/healyn_time_block.dart';
import '../features/shared/widgets/healyn_tonal_icon.dart';
import '../features/shared/widgets/healyn_week_strip.dart';

/// Throwaway showcase for the Refined Indigo shared kit. NOT wired into routes —
/// push it manually during development to eyeball every widget in one place.
class RefinedIndigoGallery extends StatefulWidget {
  const RefinedIndigoGallery({super.key});

  @override
  State<RefinedIndigoGallery> createState() => _RefinedIndigoGalleryState();
}

class _RefinedIndigoGalleryState extends State<RefinedIndigoGallery> {
  late DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 9, 30);

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const HealynHero(
            eyebrow: 'Good morning,',
            title: 'Dr. Priya Sharma',
            trailing: HealynAvatar(name: 'Priya Sharma', size: 44),
            pill: HealynHeroPill(
              icon: Icons.calendar_today_outlined,
              label: 'Saturday, 6 June 2026',
            ),
          ),
          const HealynStatRow(
            cards: [
              HealynStatCard(
                icon: Icons.event_available,
                tint: HealynColors.brandPrimary,
                value: '5',
                label: 'Today',
              ),
              HealynStatCard(
                icon: Icons.inbox_outlined,
                tint: HealynColors.statusWarning,
                value: '2',
                label: 'Requests',
              ),
              HealynStatCard(
                icon: Icons.mark_email_unread_outlined,
                tint: HealynColors.statusSuccess,
                value: '3',
                label: 'Unread',
              ),
            ],
          ),
          HealynWeekStrip(
            weekOf: _selected,
            selected: _selected,
            markedDays: {now, now.add(const Duration(days: 2))},
            onSelect: (d) => setState(() => _selected = d),
          ),
          const SizedBox(height: HealynSpacing.s5),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: HealynSpacing.screenEdge),
            child: HealynInfoBanner(
              icon: Icons.inbox_outlined,
              title: '2 new booking requests',
              subtitle: 'Tap to review & confirm',
            ),
          ),
          const SizedBox(height: HealynSpacing.s5),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: HealynSpacing.screenEdge),
            child: HealynSectionHeader(
              title: "Today's schedule",
              countLabel: '5 appts',
            ),
          ),
          const SizedBox(height: HealynSpacing.s3),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HealynSpacing.screenEdge,
            ),
            child: Column(
              children: [
                HealynListRow(
                  leading: HealynTimeBlock(
                    start: start,
                    end: start.add(const Duration(minutes: 45)),
                  ),
                  title: 'Aarav Mehta',
                  subtitle: 'Post-op knee rehab',
                  footer: const Wrap(
                    spacing: HealynSpacing.s2,
                    children: [_DemoChip('Confirmed')],
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: HealynSpacing.s3),
                HealynListRow(
                  leading: const HealynAvatar(name: 'Sara Khan', seed: 'p2'),
                  title: 'Sara Khan',
                  subtitle: 'Shoulder mobility assessment',
                  onTap: () {},
                ),
                const SizedBox(height: HealynSpacing.s3),
                HealynListRow(
                  leading: const HealynTonalIcon(
                    icon: Icons.note_alt_outlined,
                    color: HealynColors.statusInfo,
                  ),
                  title: 'Treatment note due',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: HealynSpacing.s6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: HealynSpacing.screenEdge),
            child: HealynSectionHeader(title: 'Primitives'),
          ),
          const SizedBox(height: HealynSpacing.s3),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: HealynSpacing.screenEdge,
            ),
            child: Wrap(
              spacing: HealynSpacing.s4,
              runSpacing: HealynSpacing.s4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HealynTonalIcon(
                  icon: Icons.event_available,
                  color: HealynColors.brandPrimary,
                ),
                HealynTonalIcon(
                  icon: Icons.warning_amber_outlined,
                  color: HealynColors.statusWarning,
                ),
                HealynAvatar(name: 'Aarav Mehta', seed: 'p1'),
                HealynAvatar(name: 'Sara Khan', seed: 'p2'),
                HealynAvatar(name: 'John Doe', seed: 'p3'),
              ],
            ),
          ),
          const SizedBox(height: HealynSpacing.s10),
        ],
      ),
    );
  }
}

/// A stand-in status chip so the gallery doesn't import a feature widget.
class _DemoChip extends StatelessWidget {
  const _DemoChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: HealynColors.statusSuccess.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(HealynSpacing.s1 + 2),
      ),
      child: Text(
        label,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.statusSuccess,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
