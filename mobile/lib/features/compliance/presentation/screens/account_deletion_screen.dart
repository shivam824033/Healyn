import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_info_banner.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/compliance_models.dart';
import '../compliance_providers.dart';

/// Account deletion / right-to-erasure (API_STANDARDS §9.9). When a request is
/// already open it shows the pending state with a cancel action; otherwise it
/// shows what erasure does and a password-confirmed request form. Opening a
/// request signs every device out, so on success this device is logged out and
/// returned to sign-in.
class AccountDeletionScreen extends ConsumerWidget {
  const AccountDeletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(deletionRequestControllerProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Delete account'),
      body: SafeArea(
        child: request.when(
          loading: () => const HealynListSkeleton(
            hasLeading: false,
            hasFooter: false,
            count: 4,
          ),
          error: (_, _) => ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              const ErrorBanner(
                message: 'Could not load your deletion status. Try again.',
              ),
              const SizedBox(height: HealynSpacing.s4),
              OutlinedButton(
                onPressed: () =>
                    ref.invalidate(deletionRequestControllerProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
          data: (active) => active == null
              ? const _RequestForm()
              : _PendingState(request: active),
        ),
      ),
    );
  }
}

/// Shown while a deletion request is open (the account is `PENDING_DELETION`).
class _PendingState extends ConsumerStatefulWidget {
  const _PendingState({required this.request});

  final DeletionRequestView request;

  @override
  ConsumerState<_PendingState> createState() => _PendingStateState();
}

class _PendingStateState extends ConsumerState<_PendingState> {
  bool _cancelling = false;
  String? _error;

  Future<void> _cancel() async {
    setState(() {
      _cancelling = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(deletionRequestControllerProvider.notifier).cancel();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Your account will be kept.')),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final purgeAfter = widget.request.purgeAfter?.toLocal();
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: [
        if (_error != null) ...[
          ErrorBanner(message: _error!),
          const SizedBox(height: HealynSpacing.s4),
        ],
        const HealynInfoBanner(
          icon: Icons.schedule_outlined,
          title: 'Deletion scheduled',
          subtitle: 'Your account is scheduled for deletion.',
          tone: HealynBannerTone.warning,
        ),
        const SizedBox(height: HealynSpacing.s4),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                purgeAfter == null
                    ? 'You can still cancel to keep your account.'
                    : 'You can cancel until ${_formatDate(purgeAfter)} to keep '
                        'your account. After that your account is anonymized.',
                style: HealynTypography.body,
              ),
              const SizedBox(height: HealynSpacing.s2),
              Text(
                'Your appointments, messages, and treatment notes are kept but '
                'de-identified — they are no longer linked to you.',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: HealynSpacing.s6),
        PrimaryButton(
          label: 'Keep my account',
          loading: _cancelling,
          onPressed: _cancel,
        ),
      ],
    );
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

/// The request form: explanation + password re-auth + optional reason.
class _RequestForm extends ConsumerStatefulWidget {
  const _RequestForm();

  @override
  ConsumerState<_RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends ConsumerState<_RequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _reason = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'This signs you out of every device and schedules your account for '
          'deletion. You can sign back in during the grace period to cancel.',
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
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    final auth = ref.read(authControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(deletionRequestControllerProvider.notifier).request(
            password: _password.text,
            reason: _reason.text.trim(),
          );
      if (!mounted) return;
      // The request revoked every session — sign out locally and return to the
      // sign-in screen. The user can sign back in to cancel within the grace
      // window.
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Account scheduled for deletion. Sign in again to cancel.',
          ),
        ),
      );
      await auth.logout();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            const Text('Delete your account', style: HealynTypography.h2),
            const SizedBox(height: HealynSpacing.s2),
            const Text(
              'We remove your name, contact details, and sign-in so they can no '
              'longer identify you. Your clinical records (appointments, '
              'messages, treatment notes) are kept but de-identified, as your '
              'physiotherapist is required to retain them.',
              style: HealynTypography.body,
            ),
            const SizedBox(height: HealynSpacing.s4),
            const HealynInfoBanner(
              icon: Icons.info_outline,
              title: 'There is a grace period',
              subtitle: 'You can sign back in to cancel before it completes.',
              tone: HealynBannerTone.info,
            ),
            const SizedBox(height: HealynSpacing.s6),
            AppTextField(
              label: 'Confirm your password',
              controller: _password,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                tooltip: _obscure ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter your password' : null,
            ),
            const SizedBox(height: HealynSpacing.s4),
            AppTextField(
              label: 'Reason (optional)',
              controller: _reason,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            const SizedBox(height: HealynSpacing.s7),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: HealynColors.statusDanger,
                minimumSize: const Size.fromHeight(48),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: HealynColors.textInverse,
                      ),
                    )
                  : const Text('Request account deletion'),
            ),
          ],
        ),
      ),
    );
  }
}
