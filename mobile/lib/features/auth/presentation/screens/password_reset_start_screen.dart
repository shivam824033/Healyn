import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/auth_repository.dart';
import '../../data/models/auth_models.dart';
import 'password_reset_complete_screen.dart';

/// Step 1 of "Forgot password?": collect the email or phone on the account and
/// request a reset OTP. Mirrors the register-start flow (D4) — on success it
/// pushes the complete step with the challenge id.
class PasswordResetStartScreen extends ConsumerStatefulWidget {
  const PasswordResetStartScreen({super.key});

  @override
  ConsumerState<PasswordResetStartScreen> createState() =>
      _PasswordResetStartScreenState();
}

class _PasswordResetStartScreenState
    extends ConsumerState<PasswordResetStartScreen> {
  static final RegExp _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRe = RegExp(r'^\+[1-9]\d{6,14}$');

  final _formKey = GlobalKey<FormState>();
  final _contact = TextEditingController();
  bool _useEmail = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _contact.dispose();
    super.dispose();
  }

  String? _validate(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) {
      return _useEmail ? 'Enter your email' : 'Enter your phone number';
    }
    if (_useEmail && !_emailRe.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    if (!_useEmail && !_phoneRe.hasMatch(value)) {
      return 'Use international format, e.g. +14155550123';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final value = _contact.text.trim();
    final target = _useEmail
        ? ContactTarget(email: value)
        : ContactTarget(phone: value);
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final challengeId = await ref
          .read(authRepositoryProvider)
          .startPasswordReset(target);
      if (!mounted) return;
      unawaited(
        context.push(
          '/password-reset/verify',
          extra: PasswordResetCompleteArgs(
            challengeId: challengeId,
            target: value,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HealynAppBar(title: 'Reset password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Forgot your password?', style: HealynTypography.h1),
                const SizedBox(height: HealynSpacing.s2),
                const Text(
                  "We'll send a 6-digit code to confirm it's you, then you can "
                  'set a new password.',
                  style: HealynTypography.body,
                ),
                const SizedBox(height: HealynSpacing.s6),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Email')),
                    ButtonSegment(value: false, label: Text('Phone')),
                  ],
                  selected: {_useEmail},
                  onSelectionChanged: _submitting
                      ? null
                      : (s) => setState(() {
                          _useEmail = s.first;
                          _contact.clear();
                        }),
                ),
                const SizedBox(height: HealynSpacing.s4),
                if (_error != null) ...[
                  ErrorBanner(message: _error!),
                  const SizedBox(height: HealynSpacing.s4),
                ],
                AppTextField(
                  label: _useEmail ? 'Email' : 'Phone number',
                  controller: _contact,
                  hintText: _useEmail ? 'you@example.com' : '+14155550123',
                  keyboardType: _useEmail
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: _validate,
                ),
                const SizedBox(height: HealynSpacing.s7),
                PrimaryButton(
                  label: 'Send code',
                  loading: _submitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: HealynSpacing.s4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remembered it?',
                      style: HealynTypography.body,
                    ),
                    TextButton(
                      onPressed: _submitting ? null : () => context.go('/login'),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
