import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healyn/features/shared/design/colors.dart';

import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/field_label.dart';
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
  final _line1 = TextEditingController();
  final _line2 = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _postalCode = TextEditingController();
  final _country = TextEditingController(text: 'India');
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
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    _state.dispose();
    _postalCode.dispose();
    _country.dispose();
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
            address: Address(
              line1: _line1.text.trim(),
              line2: _line2.text.trim().isEmpty ? null : _line2.text.trim(),
              city: _city.text.trim(),
              state: _state.text.trim(),
              postalCode: _postalCode.text.trim(),
              country: _country.text.trim().isEmpty
                  ? 'India'
                  : _country.text.trim(),
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
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Verify & finish'),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FieldLabel('Sex (optional)'),
                    DropdownButtonFormField<PatientSex>(
                      initialValue: _sex,
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
                  ],
                ),
                const SizedBox(height: HealynSpacing.s6),
                const Text('Your address', style: HealynTypography.h3),
                const SizedBox(height: HealynSpacing.s1),
                const Text(
                  'Shared across your family and used by your physiotherapist '
                  'for communication and records.',
                  style: HealynTypography.caption,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Address line 1',
                  controller: _line1,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.streetAddressLine1],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your address'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Address line 2 (optional)',
                  controller: _line2,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.streetAddressLine2],
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'City',
                  controller: _city,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.addressCity],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your city'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'State',
                  controller: _state,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.addressState],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your state'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'PIN / postal code',
                  controller: _postalCode,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.postalCode],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your PIN code'
                      : null,
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Country',
                  controller: _country,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.countryName],
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter your country'
                      : null,
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
