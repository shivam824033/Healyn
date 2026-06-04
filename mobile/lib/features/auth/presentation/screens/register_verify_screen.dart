import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/auth_repository.dart';
import '../../data/models/auth_models.dart';
import '../controllers/auth_controller.dart';

/// Carries the challenge id (and the contact it was sent to, for display) from
/// the register-start step into this verify step.
class RegisterVerifyArgs {
  const RegisterVerifyArgs({required this.challengeId, required this.target});

  final String challengeId;
  final String target;
}

class RegisterVerifyScreen extends ConsumerStatefulWidget {
  const RegisterVerifyScreen({required this.args, super.key});

  final RegisterVerifyArgs args;

  @override
  ConsumerState<RegisterVerifyScreen> createState() =>
      _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends ConsumerState<RegisterVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _dobField = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;
  DateTime? _dob;
  PatientSex? _sex;

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _fullName.dispose();
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
      initialDate: DateTime(now.year - 30),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      setState(() => _error = 'Select your date of birth.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .completeRegistration(
            challengeId: widget.args.challengeId,
            code: _code.text.trim(),
            password: _password.text,
            profile: PrimaryPatientProfile(
              fullName: _fullName.text.trim(),
              dateOfBirth: _dob!,
              sex: _sex,
            ),
          );
      if (!mounted) return;
      await ref.read(authControllerProvider.notifier).markAuthenticated();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify & finish')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Enter your code', style: HealynTypography.h1),
                const SizedBox(height: HealynSpacing.s2),
                Text(
                  'We sent a 6-digit code to ${widget.args.target}. '
                  'Set a password and tell us a little about you.',
                  style: HealynTypography.body,
                ),
                const SizedBox(height: HealynSpacing.s6),
                if (_error != null) ...[
                  ErrorBanner(message: _error!),
                  const SizedBox(height: HealynSpacing.s4),
                ],
                AppTextField(
                  label: 'Verification code',
                  controller: _code,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (v) => (v == null || v.trim().length != 6)
                      ? 'Enter the 6-digit code'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Password',
                  controller: _password,
                  obscureText: _obscure,
                  hintText: 'At least 10 characters',
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) => (v == null || v.length < 10)
                      ? 'Use at least 10 characters'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Full name',
                  controller: _fullName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your full name'
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
                DropdownButtonFormField<PatientSex>(
                  initialValue: _sex,
                  decoration: const InputDecoration(
                    labelText: 'Sex (optional)',
                  ),
                  items: PatientSex.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label),
                        ),
                      )
                      .toList(),
                  onChanged: _submitting
                      ? null
                      : (v) => setState(() => _sex = v),
                ),
                const SizedBox(height: HealynSpacing.s7),
                PrimaryButton(
                  label: 'Create account',
                  loading: _submitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
