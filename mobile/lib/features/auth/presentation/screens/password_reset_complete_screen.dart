import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Carries the challenge id (and the contact it was sent to, for display) from
/// the reset-start step into this complete step.
class PasswordResetCompleteArgs {
  const PasswordResetCompleteArgs({
    required this.challengeId,
    required this.target,
  });

  final String challengeId;
  final String target;
}

/// Step 2 of "Forgot password?": enter the OTP and a new password. The backend
/// issues no session here (204), so on success this returns to sign-in (D4).
class PasswordResetCompleteScreen extends ConsumerStatefulWidget {
  const PasswordResetCompleteScreen({required this.args, super.key});

  final PasswordResetCompleteArgs args;

  @override
  ConsumerState<PasswordResetCompleteScreen> createState() =>
      _PasswordResetCompleteScreenState();
}

class _PasswordResetCompleteScreenState
    extends ConsumerState<PasswordResetCompleteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(authRepositoryProvider)
          .completePasswordReset(
            challengeId: widget.args.challengeId,
            code: _code.text.trim(),
            newPassword: _password.text,
          );
      if (!mounted) return;
      // No session is issued — send the user back to sign in with the new
      // password. The root messenger keeps the confirmation visible across the
      // navigation.
      router.go('/login');
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Password updated. Sign in with your new password.'),
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
                const Text('Enter your code', style: HealynTypography.h1),
                const SizedBox(height: HealynSpacing.s2),
                Text(
                  'We sent a 6-digit code to ${widget.args.target}. '
                  'Enter it and choose a new password.',
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
                  label: 'New password',
                  controller: _password,
                  obscureText: _obscure,
                  hintText: 'At least 10 characters',
                  textInputAction: TextInputAction.done,
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
                const SizedBox(height: HealynSpacing.s7),
                PrimaryButton(
                  label: 'Reset password',
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
