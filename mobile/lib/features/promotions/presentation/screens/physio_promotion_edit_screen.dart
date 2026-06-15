import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../files/data/file_picker_service.dart';
import '../../../files/data/file_types.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../data/models/promotion_models.dart';
import '../../data/promotions_repository.dart';
import '../widgets/promotion_cover.dart';

/// Create or edit a clinic promotion (physiotherapist only). On create, the cover
/// (if chosen) uploads after the promotion row exists, so its object key can be
/// scoped to the new id. Pops `true` when something changed so the manager refetches.
class PhysioPromotionEditScreen extends ConsumerStatefulWidget {
  const PhysioPromotionEditScreen({this.existing, super.key});

  final ManagedPromotion? existing;

  bool get isEdit => existing != null;

  @override
  ConsumerState<PhysioPromotionEditScreen> createState() =>
      _PhysioPromotionEditScreenState();
}

class _PhysioPromotionEditScreenState
    extends ConsumerState<PhysioPromotionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _shortDescription = TextEditingController();
  final _longDescription = TextEditingController();
  final _category = TextEditingController();
  final _ctaText = TextEditingController();

  PromotionAction _action = PromotionAction.none;
  bool _active = true;
  DateTime? _startsAt;
  DateTime? _endsAt;

  // A freshly picked cover, not yet uploaded; null means "keep what's there".
  Uint8List? _pickedBytes;
  String? _pickedMime;
  String? _existingCoverUrl;

  bool _saving = false;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _title.text = e.title;
      _shortDescription.text = e.shortDescription ?? '';
      _longDescription.text = e.longDescription ?? '';
      _category.text = e.serviceCategory ?? '';
      _ctaText.text = e.ctaText ?? '';
      _action = e.ctaAction;
      _active = e.active;
      _startsAt = e.startsAt?.toLocal();
      _endsAt = e.endsAt?.toLocal();
      _existingCoverUrl = e.coverUrl;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _shortDescription,
      _longDescription,
      _category,
      _ctaText,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickCover() async {
    final source = await showModalBottomSheet<PickSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(ctx, PickSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose photo'),
              onTap: () => Navigator.pop(ctx, PickSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    setState(() => _picking = true);
    PickedFile? picked;
    try {
      picked = await ref.read(filePickerServiceProvider).pick(source);
    } catch (_) {
      _toast("Couldn't open the picker.");
      setState(() => _picking = false);
      return;
    }
    if (picked == null) {
      setState(() => _picking = false);
      return;
    }

    final type = uploadTypeForFilename(picked.filename);
    if (type == null || !type.mimeType.startsWith('image/')) {
      _toast('Choose a JPG, PNG, or WEBP image.');
      setState(() => _picking = false);
      return;
    }
    if (picked.bytes.length > type.maxBytes) {
      _toast('That image is too large. Choose one under 10 MB.');
      setState(() => _picking = false);
      return;
    }
    setState(() {
      _pickedBytes = Uint8List.fromList(picked!.bytes);
      _pickedMime = type.mimeType;
      _picking = false;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_startsAt != null && _endsAt != null && !_endsAt!.isAfter(_startsAt!)) {
      _toast('The end date must be after the start date.');
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(promotionsRepositoryProvider);
    try {
      String id;
      if (widget.isEdit) {
        await repo.update(
          widget.existing!.id,
          UpdatePromotionRequest(
            title: _title.text.trim(),
            shortDescription: _shortDescription.text.trim(),
            longDescription: _longDescription.text.trim(),
            serviceCategory: _category.text.trim(),
            ctaText: _ctaText.text.trim(),
            ctaAction: _action,
            startsAt: _startsAt?.toUtc(),
            endsAt: _endsAt?.toUtc(),
          ),
        );
        id = widget.existing!.id;
      } else {
        final created = await repo.create(
          CreatePromotionRequest(
            title: _title.text.trim(),
            shortDescription: _emptyToNull(_shortDescription.text),
            longDescription: _emptyToNull(_longDescription.text),
            serviceCategory: _emptyToNull(_category.text),
            ctaText: _emptyToNull(_ctaText.text),
            ctaAction: _action,
            startsAt: _startsAt?.toUtc(),
            endsAt: _endsAt?.toUtc(),
            active: _active,
          ),
        );
        id = created.id;
      }

      if (_pickedBytes != null && _pickedMime != null) {
        await repo.uploadCover(id: id, bytes: _pickedBytes!, mimeType: _pickedMime!);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(e.message);
    }
  }

  Future<void> _pickDate({required bool start}) async {
    final now = DateTime.now();
    final initial = (start ? _startsAt : _endsAt) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _startsAt = DateTime(picked.year, picked.month, picked.day);
      } else {
        // Inclusive end-of-day so a promotion stays visible through the chosen date.
        _endsAt = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
      }
    });
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static String? _emptyToNull(String s) => s.trim().isEmpty ? null : s.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: widget.isEdit ? 'Edit promotion' : 'New promotion',
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              _coverPicker(),
              const SizedBox(height: HealynSpacing.s5),
              const HealynSectionHeader(title: 'Content'),
              const SizedBox(height: HealynSpacing.s3),
              _field(
                _title,
                'Title',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'A title is required' : null,
              ),
              _field(_shortDescription, 'Short description', maxLines: 2),
              _field(_longDescription, 'Detailed description', maxLines: 6),
              _field(_category, 'Service category'),
              const SizedBox(height: HealynSpacing.s5),
              const HealynSectionHeader(title: 'Action button'),
              const SizedBox(height: HealynSpacing.s3),
              _actionDropdown(),
              if (_action != PromotionAction.none) ...[
                const SizedBox(height: HealynSpacing.s3),
                _field(_ctaText, 'Button label (e.g. "Book now")'),
              ],
              const SizedBox(height: HealynSpacing.s5),
              const HealynSectionHeader(title: 'Schedule (optional)'),
              const SizedBox(height: HealynSpacing.s3),
              _dateRow('Starts', _startsAt, () => _pickDate(start: true),
                  () => setState(() => _startsAt = null)),
              const SizedBox(height: HealynSpacing.s2),
              _dateRow('Ends', _endsAt, () => _pickDate(start: false),
                  () => setState(() => _endsAt = null)),
              if (!widget.isEdit) ...[
                const SizedBox(height: HealynSpacing.s5),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show to patients now'),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
              ],
              const SizedBox(height: HealynSpacing.s6),
              FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(widget.isEdit ? 'Save changes' : 'Create promotion'),
              ),
              const SizedBox(height: HealynSpacing.s8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverPicker() {
    final Widget preview;
    if (_pickedBytes != null) {
      preview = ClipRRect(
        borderRadius: HealynRadii.brLg,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.memory(_pickedBytes!, fit: BoxFit.cover),
        ),
      );
    } else {
      preview = PromotionCover(
        url: _existingCoverUrl,
        aspectRatio: 16 / 9,
        seed: _title.text.isEmpty ? 'promotion' : _title.text,
        borderRadius: HealynRadii.brLg,
      );
    }
    return Column(
      children: [
        preview,
        const SizedBox(height: HealynSpacing.s2),
        TextButton.icon(
          onPressed: _picking ? null : _pickCover,
          icon: const Icon(Icons.image_outlined),
          label: Text(
            _pickedBytes != null || (_existingCoverUrl?.isNotEmpty ?? false)
                ? 'Change cover image'
                : 'Add cover image',
          ),
        ),
      ],
    );
  }

  Widget _actionDropdown() {
    return DropdownButtonFormField<PromotionAction>(
      initialValue: _action,
      decoration: const InputDecoration(
        labelText: 'On tap',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: PromotionAction.none,
          child: Text('No button (info only)'),
        ),
        DropdownMenuItem(
          value: PromotionAction.bookAppointment,
          child: Text('Book appointment'),
        ),
        DropdownMenuItem(
          value: PromotionAction.callClinic,
          child: Text('Call the clinic'),
        ),
      ],
      onChanged: (v) => setState(() => _action = v ?? PromotionAction.none),
    );
  }

  Widget _dateRow(
    String label,
    DateTime? value,
    VoidCallback onPick,
    VoidCallback onClear,
  ) {
    final text = value == null
        ? 'Not set'
        : '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: HealynTypography.bodyStrong),
        ),
        Expanded(
          child: Text(
            text,
            style: HealynTypography.body.copyWith(
              color: value == null
                  ? HealynColors.textMuted
                  : HealynColors.textPrimary,
            ),
          ),
        ),
        if (value != null)
          IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.clear, size: 18),
            onPressed: onClear,
          ),
        TextButton(onPressed: onPick, child: const Text('Pick date')),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HealynSpacing.s3),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
