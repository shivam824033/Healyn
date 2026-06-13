import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../data/models/discussion_models.dart';
import '../discussion_format.dart';

/// One message in the thread. [isOutgoing] is true for the viewer's own side —
/// outgoing bubbles sit on the right with the brand fill; the other side sits on
/// the left. An [DiscussionMessageType.instruction] message renders as an
/// emphasised instruction card regardless of side (incoming for the patient,
/// outgoing for the physio who wrote it).
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isOutgoing,
    this.onOpenAttachment,
    super.key,
  });

  final DiscussionMessage message;
  final bool isOutgoing;

  /// Invoked when an attachment chip is tapped; the host resolves the file to a
  /// presigned URL and opens it. When null the chips are non-interactive.
  final void Function(MessageAttachment attachment)? onOpenAttachment;

  bool get _isInstruction =>
      message.messageType == DiscussionMessageType.instruction;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;
    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: _isInstruction ? _instruction(context) : _bubble(context),
      ),
    );
  }

  Widget _bubble(BuildContext context) {
    final bg = isOutgoing
        ? HealynColors.brandPrimary
        : HealynColors.surfaceAlt;
    final fg = isOutgoing ? HealynColors.textInverse : HealynColors.textPrimary;
    final footer = isOutgoing
        ? HealynColors.textInverse.withValues(alpha: 0.8)
        : HealynColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s4,
        vertical: HealynSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(HealynRadii.lg),
        border: isOutgoing
            ? null
            : Border.all(color: HealynColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.body != null && message.body!.isNotEmpty)
            Text(message.body!, style: HealynTypography.body.copyWith(color: fg)),
          if (message.attachments.isNotEmpty) ...[
            if (message.body != null && message.body!.isNotEmpty)
              const SizedBox(height: HealynSpacing.s2),
            ..._attachments(onLight: !isOutgoing),
          ],
          const SizedBox(height: HealynSpacing.s1),
          _footer(footer),
        ],
      ),
    );
  }

  Widget _instruction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HealynSpacing.s4),
      decoration: BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: BorderRadius.circular(HealynRadii.lg),
        border: const Border(
          left: BorderSide(color: HealynColors.brandPrimary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INSTRUCTION',
            style: HealynTypography.overline.copyWith(
              color: HealynColors.brandPrimary,
            ),
          ),
          const SizedBox(height: HealynSpacing.s1),
          if (message.body != null && message.body!.isNotEmpty)
            Text(message.body!, style: HealynTypography.body),
          if (message.attachments.isNotEmpty) ...[
            const SizedBox(height: HealynSpacing.s2),
            ..._attachments(onLight: true),
          ],
          const SizedBox(height: HealynSpacing.s1),
          _footer(HealynColors.textMuted),
        ],
      ),
    );
  }

  List<Widget> _attachments({required bool onLight}) {
    return [
      for (final a in message.attachments)
        Padding(
          padding: const EdgeInsets.only(top: HealynSpacing.s1),
          child: _AttachmentChip(
            attachment: a,
            onLight: onLight,
            onTap: onOpenAttachment == null ? null : () => onOpenAttachment!(a),
          ),
        ),
    ];
  }

  Widget _footer(Color color) {
    final edited = message.editedAt != null ? ' · edited' : '';
    return Text(
      '${formatClockTime(message.createdAt)}$edited',
      style: HealynTypography.caption.copyWith(color: color),
    );
  }
}

/// A chip naming an attached file. When [onTap] is set, tapping resolves the
/// file to a presigned URL and opens it (F1.15); otherwise it is metadata only.
class _AttachmentChip extends StatelessWidget {
  const _AttachmentChip({
    required this.attachment,
    required this.onLight,
    this.onTap,
  });

  final MessageAttachment attachment;
  final bool onLight;
  final VoidCallback? onTap;

  IconData get _icon {
    final mime = attachment.mimeType.toLowerCase();
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime == 'application/pdf') return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final fg = onLight ? HealynColors.textSecondary : HealynColors.textInverse;
    final border = onLight
        ? HealynColors.borderSubtle
        : HealynColors.textInverse.withValues(alpha: 0.4);
    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: HealynSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: onLight
            ? HealynColors.surfaceBase
            : HealynColors.textInverse.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(HealynRadii.sm),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 18, color: fg),
          const SizedBox(width: HealynSpacing.s2),
          Flexible(
            child: Text(
              attachment.originalFilename,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HealynTypography.caption.copyWith(color: fg),
            ),
          ),
          const SizedBox(width: HealynSpacing.s2),
          Text(
            formatBytes(attachment.sizeBytes),
            style: HealynTypography.caption.copyWith(color: fg),
          ),
          if (onTap != null) ...[
            const SizedBox(width: HealynSpacing.s2),
            Icon(Icons.open_in_new, size: 14, color: fg),
          ],
        ],
      ),
    );
    if (onTap == null) return chip;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: chip,
    );
  }
}
