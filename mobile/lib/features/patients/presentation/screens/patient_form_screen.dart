import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/field_label.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/models/patient_models.dart';
import '../../data/patients_repository.dart';
import '../patients_providers.dart';

/// Create or edit a patient. Two entry points:
/// - [PatientFormScreen.create] adds a family member (relationship required).
/// - [PatientFormScreen.edit] edits an existing patient; the primary patient
///   has no relationship field and cannot be removed.
///
/// On success it invalidates [patientsProvider] (so Family/Profile refresh) and
/// pops. Clinical fields (allergies, notes) are PHI — never log their contents.
class PatientFormScreen extends ConsumerStatefulWidget {
  const PatientFormScreen.create({super.key}) : patient = null;

  const PatientFormScreen.edit({required Patient this.patient, super.key});

  final Patient? patient;

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRe = RegExp(r'^\+[1-9]\d{6,14}$');

  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _bloodGroup = TextEditingController();
  final _allergies = TextEditingController();
  final _notes = TextEditingController();
  final _dobField = TextEditingController();

  DateTime? _dob;
  PatientSex? _sex;
  PatientRelationship? _relationship;
  bool _submitting = false;
  String? _error;

  bool get _isEditing => widget.patient != null;
  bool get _isPrimary => widget.patient?.primary ?? false;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    if (p != null) {
      _fullName.text = p.fullName;
      _phone.text = p.phoneE164 ?? '';
      _email.text = p.email ?? '';
      _bloodGroup.text = p.bloodGroup ?? '';
      _allergies.text = p.allergies ?? '';
      _notes.text = p.notes ?? '';
      _dob = p.dateOfBirth;
      _dobField.text = _formatDate(p.dateOfBirth);
      _sex = p.sex;
      _relationship = p.relationship;
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _bloodGroup.dispose();
    _allergies.dispose();
    _notes.dispose();
    _dobField.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30),
      firstDate: DateTime(1900),
      lastDate: today.subtract(const Duration(days: 1)),
      helpText: 'Date of birth',
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobField.text = _formatDate(picked);
      });
    }
  }

  String? _validatePhone(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return null; // optional
    return _phoneRe.hasMatch(value)
        ? null
        : 'Use international format, e.g. +14155550123';
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return null; // optional
    return _emailRe.hasMatch(value) ? null : 'Enter a valid email address';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      setState(() => _error = 'Select a date of birth.');
      return;
    }
    if (!_isEditing && _relationship == null) {
      setState(() => _error = 'Choose how this person relates to you.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final repo = ref.read(patientsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_isEditing) {
        await repo.update(
          widget.patient!.id,
          UpdatePatientRequest(
            fullName: _fullName.text.trim(),
            dateOfBirth: _dob!,
            sex: _sex,
            phoneE164: _phone.text.trim(),
            email: _email.text.trim(),
            bloodGroup: _bloodGroup.text.trim(),
            allergies: _allergies.text.trim(),
            notes: _notes.text.trim(),
          ),
        );
      } else {
        await repo.create(
          CreateFamilyMemberRequest(
            fullName: _fullName.text.trim(),
            dateOfBirth: _dob!,
            relationship: _relationship!,
            sex: _sex,
            phoneE164: _phone.text.trim(),
            email: _email.text.trim(),
            bloodGroup: _bloodGroup.text.trim(),
            allergies: _allergies.text.trim(),
            notes: _notes.text.trim(),
          ),
        );
      }
      ref.invalidate(patientsProvider);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Changes saved' : 'Family member added')),
      );
      context.pop();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _remove() async {
    final patient = widget.patient!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove family member?'),
        content: Text(
          '${patient.fullName} will be removed from your family. '
          'Their appointment history is kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: HealynColors.statusDanger,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(patientsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.remove(patient.id);
      ref.invalidate(patientsProvider);
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Family member removed')));
      context.pop();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = !_isEditing
        ? 'Add family member'
        : _isPrimary
        ? 'Edit profile'
        : 'Edit family member';

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(title: title),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null) ...[
                  ErrorBanner(message: _error!),
                  const SizedBox(height: HealynSpacing.s4),
                ],
                AppTextField(
                  label: 'Full name',
                  controller: _fullName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter a full name'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Date of birth',
                  controller: _dobField,
                  readOnly: true,
                  onTap: _submitting ? null : _pickDob,
                  hintText: 'Select a date',
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                const SizedBox(height: HealynSpacing.s4),
                if (!_isEditing) ...[
                  _RelationshipField(
                    value: _relationship,
                    enabled: !_submitting,
                    onChanged: (v) => setState(() => _relationship = v),
                  ),
                  const SizedBox(height: HealynSpacing.s4),
                ],
                _SexField(
                  value: _sex,
                  enabled: !_submitting,
                  onChanged: (v) => setState(() => _sex = v),
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Phone (optional)',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  hintText: '+14155550123',
                  validator: _validatePhone,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Email (optional)',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hintText: 'you@example.com',
                  validator: _validateEmail,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Blood group (optional)',
                  controller: _bloodGroup,
                  textInputAction: TextInputAction.next,
                  hintText: 'e.g. O+',
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Allergies (optional)',
                  controller: _allergies,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Notes (optional)',
                  controller: _notes,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: HealynSpacing.s7),
                PrimaryButton(
                  label: _isEditing ? 'Save changes' : 'Add family member',
                  loading: _submitting,
                  onPressed: _submit,
                ),
                if (_isEditing && !_isPrimary) ...[
                  const SizedBox(height: HealynSpacing.s4),
                  OutlinedButton.icon(
                    onPressed: _submitting ? null : _remove,
                    icon: const Icon(Icons.person_remove_outlined),
                    label: const Text('Remove family member'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: HealynColors.statusDanger,
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: HealynColors.borderSubtle),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RelationshipField extends StatelessWidget {
  const _RelationshipField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final PatientRelationship? value;
  final bool enabled;
  final ValueChanged<PatientRelationship?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel('Relationship'),
        DropdownButtonFormField<PatientRelationship>(
          initialValue: value,
          items: PatientRelationship.values
              .where((r) => r != PatientRelationship.self)
              .map((r) => DropdownMenuItem(value: r, child: Text(r.label)))
              .toList(),
          onChanged: enabled ? onChanged : null,
          validator: (v) => v == null ? 'Choose a relationship' : null,
        ),
      ],
    );
  }
}

class _SexField extends StatelessWidget {
  const _SexField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final PatientSex? value;
  final bool enabled;
  final ValueChanged<PatientSex?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel('Sex (optional)'),
        DropdownButtonFormField<PatientSex>(
          initialValue: value,
          items: PatientSex.values
              .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
