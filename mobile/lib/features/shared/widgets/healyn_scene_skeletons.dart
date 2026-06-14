import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import 'app_bar.dart';
import 'healyn_shimmer.dart';
import 'healyn_skeletons.dart';
import 'section_card.dart';

/// Full-screen first-load placeholders for *destinations reached by a deep link*
/// (a notification tap or a refresh that lands without the object in `extra`),
/// shown by the router while the id resolves. Each mirrors the broad shape of
/// the screen it stands in for — the brand app bar plus the destination's body
/// footprint — so the resolved screen fades in over the same layout instead of
/// replacing a bare, centred spinner.

/// Stand-in for a detail destination (an appointment or a patient): a header
/// summary card with a status pill, followed by a few section-card skeletons.
class HealynDetailSceneSkeleton extends StatelessWidget {
  const HealynDetailSceneSkeleton({this.sectionCount = 2, super.key});

  /// How many body section-card skeletons to show beneath the header card.
  final int sectionCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(),
      body: HealynSkeletonGroup(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            // Header summary card: a title line, a status pill, a meta line.
            const SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HealynSkeletonLine(widthFactor: 0.6, height: 18),
                  SizedBox(height: HealynSpacing.s3),
                  HealynSkeletonBox(
                    width: 96,
                    height: 24,
                    radius: BorderRadius.all(Radius.circular(HealynRadii.full)),
                  ),
                  SizedBox(height: HealynSpacing.s3),
                  HealynSkeletonLine(widthFactor: 0.45, height: 13),
                ],
              ),
            ),
            for (var i = 0; i < sectionCount; i++) ...[
              const SizedBox(height: HealynSpacing.s4),
              const SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HealynSkeletonLine(widthFactor: 0.3, height: 11),
                    SizedBox(height: HealynSpacing.s3),
                    HealynSkeletonLine(widthFactor: 0.9, height: 13),
                    SizedBox(height: HealynSpacing.s2),
                    HealynSkeletonLine(widthFactor: 0.72, height: 13),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Stand-in for a discussion thread: the brand app bar over a run of message
/// bubble skeletons ([HealynChatSkeleton]) with a composer-bar placeholder
/// pinned below, so the thread doesn't reflow when the real input arrives.
class HealynChatSceneSkeleton extends StatelessWidget {
  const HealynChatSceneSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(),
      body: Column(
        children: [
          const Expanded(child: HealynChatSkeleton()),
          Container(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            decoration: const BoxDecoration(
              color: HealynColors.surfaceBase,
              border: Border(
                top: BorderSide(color: HealynColors.borderSubtle),
              ),
            ),
            child: const HealynSkeletonGroup(
              child: Row(
                children: [
                  Expanded(
                    child: HealynSkeletonBox(height: 40, radius: HealynRadii.brLg),
                  ),
                  SizedBox(width: HealynSpacing.s3),
                  HealynSkeletonBox(
                    width: 40,
                    height: 40,
                    radius: BorderRadius.all(Radius.circular(HealynRadii.full)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stand-in for an edit/reschedule form: the brand app bar over a column of
/// label + input-field skeletons and a submit-button placeholder.
class HealynFormSceneSkeleton extends StatelessWidget {
  const HealynFormSceneSkeleton({this.fieldCount = 4, super.key});

  /// How many label + input pairs to show above the submit-button placeholder.
  final int fieldCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(),
      body: HealynSkeletonGroup(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            for (var i = 0; i < fieldCount; i++) ...[
              const HealynSkeletonLine(widthFactor: 0.32, height: 12),
              const SizedBox(height: HealynSpacing.s2),
              const HealynSkeletonBox(height: 48, radius: HealynRadii.brMd),
              const SizedBox(height: HealynSpacing.s4),
            ],
            const SizedBox(height: HealynSpacing.s2),
            const HealynSkeletonBox(height: 48, radius: HealynRadii.brMd),
          ],
        ),
      ),
    );
  }
}
