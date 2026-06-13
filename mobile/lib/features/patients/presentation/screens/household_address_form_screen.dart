import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/domain/address.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/patients_repository.dart';
import '../patients_providers.dart';

/// Edit the account's household address (`PUT /account/address`). The same
/// address is shared by every patient on the account, so it is edited here once
/// rather than per patient. [initial] prefills the form when editing; it is null
/// when the account has no address yet. On success it invalidates the patients
/// list and the address provider (so Profile and every patient view refresh).
class HouseholdAddressFormScreen extends ConsumerStatefulWidget {
  const HouseholdAddressFormScreen({this.initial, super.key});

  final Address? initial;

  @override
  ConsumerState<HouseholdAddressFormScreen> createState() =>
      _HouseholdAddressFormScreenState();
}

class _HouseholdAddressFormScreenState
    extends ConsumerState<HouseholdAddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _line1;
  late final TextEditingController _line2;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _postalCode;
  late final TextEditingController _country;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    _line1 = TextEditingController(text: a?.line1 ?? '');
    _line2 = TextEditingController(text: a?.line2 ?? '');
    _city = TextEditingController(text: a?.city ?? '');
    _state = TextEditingController(text: a?.state ?? '');
    _postalCode = TextEditingController(text: a?.postalCode ?? '');
    _country = TextEditingController(text: a?.country ?? 'India');
  }

  @override
  void dispose() {
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    _state.dispose();
    _postalCode.dispose();
    _country.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(patientsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.saveAccountAddress(
        Address(
          line1: _line1.text.trim(),
          line2: _line2.text.trim().isEmpty ? null : _line2.text.trim(),
          city: _city.text.trim(),
          state: _state.text.trim(),
          postalCode: _postalCode.text.trim(),
          country: _country.text.trim().isEmpty ? 'India' : _country.text.trim(),
        ),
      );
      ref.invalidate(accountAddressProvider);
      ref.invalidate(patientsProvider);
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Address saved')));
      context.pop();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Address'),
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
                  label: 'Address line 1',
                  controller: _line1,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.streetAddressLine1],
                  validator: (v) => _required(v, 'Enter your address'),
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
                  validator: (v) => _required(v, 'Enter your city'),
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'State',
                  controller: _state,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.addressState],
                  validator: (v) => _required(v, 'Enter your state'),
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'PIN / postal code',
                  controller: _postalCode,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.postalCode],
                  validator: (v) => _required(v, 'Enter your PIN code'),
                ),
                const SizedBox(height: HealynSpacing.s4),
                AppTextField(
                  label: 'Country',
                  controller: _country,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.countryName],
                  validator: (v) => _required(v, 'Enter your country'),
                ),
                const SizedBox(height: HealynSpacing.s7),
                PrimaryButton(
                  label: 'Save address',
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
