import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../files/data/file_picker_service.dart';
import '../../../files/data/file_types.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/healyn_avatar.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/physio_profile_models.dart';
import '../../data/physio_profile_repository.dart';

/// The physiotherapist's profile editor (personal, clinic, social links + avatar).
/// Saved details surface on the patient home screen. URL fields are validated to
/// mirror the server (empty or http(s)://…); the avatar uploads through the same
/// presign → PUT → confirm pipeline as documents.
class PhysioProfileEditScreen extends ConsumerStatefulWidget {
  const PhysioProfileEditScreen({super.key});

  @override
  ConsumerState<PhysioProfileEditScreen> createState() =>
      _PhysioProfileEditScreenState();
}

class _PhysioProfileEditScreenState
    extends ConsumerState<PhysioProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayName = TextEditingController();
  final _qualification = TextEditingController();
  final _experience = TextEditingController();
  final _specialization = TextEditingController();
  final _bio = TextEditingController();
  final _clinicName = TextEditingController();
  final _clinicAddress = TextEditingController();
  final _clinicPhone = TextEditingController();
  final _clinicDescription = TextEditingController();
  final _instagram = TextEditingController();
  final _facebook = TextEditingController();
  final _linkedin = TextEditingController();
  final _website = TextEditingController();

  bool _initialized = false;
  bool _saving = false;
  bool _uploadingAvatar = false;
  String? _avatarUrl;

  @override
  void dispose() {
    for (final c in [
      _displayName,
      _qualification,
      _experience,
      _specialization,
      _bio,
      _clinicName,
      _clinicAddress,
      _clinicPhone,
      _clinicDescription,
      _instagram,
      _facebook,
      _linkedin,
      _website,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _hydrate(PhysioProfile p) {
    _displayName.text = p.displayName ?? '';
    _qualification.text = p.qualification ?? '';
    _experience.text = p.experienceYears?.toString() ?? '';
    _specialization.text = p.specialization ?? '';
    _bio.text = p.bio ?? '';
    _clinicName.text = p.clinicName ?? '';
    _clinicAddress.text = p.clinicAddress ?? '';
    _clinicPhone.text = p.clinicContactPhone ?? '';
    _clinicDescription.text = p.clinicDescription ?? '';
    _instagram.text = p.instagramUrl ?? '';
    _facebook.text = p.facebookUrl ?? '';
    _linkedin.text = p.linkedinUrl ?? '';
    _website.text = p.websiteUrl ?? '';
    _avatarUrl = p.avatarUrl;
    _initialized = true;
  }

  String? _validateUrl(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (!RegExp(r'^https?://\S+$').hasMatch(v)) {
      return 'Enter a full URL starting with http:// or https://';
    }
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final years = int.tryParse(_experience.text.trim());
    final body = UpdatePhysioProfileRequest(
      displayName: _displayName.text.trim(),
      qualification: _qualification.text.trim(),
      experienceYears: years,
      specialization: _specialization.text.trim(),
      bio: _bio.text.trim(),
      clinicName: _clinicName.text.trim(),
      clinicAddress: _clinicAddress.text.trim(),
      clinicContactPhone: _clinicPhone.text.trim(),
      clinicDescription: _clinicDescription.text.trim(),
      instagramUrl: _instagram.text.trim(),
      facebookUrl: _facebook.text.trim(),
      linkedinUrl: _linkedin.text.trim(),
      websiteUrl: _website.text.trim(),
    );
    try {
      await ref.read(physioProfileRepositoryProvider).update(body);
      ref.invalidate(physioProfileProvider);
      if (!mounted) return;
      _toast('Profile saved.');
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(e.message);
    }
  }

  Future<void> _pickAvatar() async {
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

    PickedFile? picked;
    try {
      picked = await ref.read(filePickerServiceProvider).pick(source);
    } catch (_) {
      _toast("Couldn't open the picker.");
      return;
    }
    if (picked == null) return;

    final type = uploadTypeForFilename(picked.filename);
    if (type == null || !type.mimeType.startsWith('image/')) {
      _toast('Choose a JPG or PNG image.');
      return;
    }

    setState(() => _uploadingAvatar = true);
    try {
      final updated = await ref
          .read(physioProfileRepositoryProvider)
          .uploadAvatar(bytes: picked.bytes, mimeType: type.mimeType);
      ref.invalidate(physioProfileProvider);
      if (!mounted) return;
      setState(() {
        _avatarUrl = updated.avatarUrl;
        _uploadingAvatar = false;
      });
      _toast('Photo updated.');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _uploadingAvatar = false);
      _toast(e.message);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(physioProfileProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Edit profile'),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const HealynListSkeleton(hasLeading: false),
          error: (_, _) => const Center(
            child: Padding(
              padding: EdgeInsets.all(HealynSpacing.screenEdge),
              child: Text(
                'Could not load your profile. Pull back and try again.',
                style: HealynTypography.body,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (profile) {
            if (!_initialized) _hydrate(profile);
            return _form();
          },
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        children: [
          _avatarRow(),
          const SizedBox(height: HealynSpacing.s6),
          const HealynSectionHeader(title: 'Personal details'),
          const SizedBox(height: HealynSpacing.s3),
          _field(_displayName, 'Full name', textInputAction: TextInputAction.next),
          _field(_qualification, 'Qualification'),
          _field(
            _experience,
            'Years of experience',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          _field(_specialization, 'Specialization'),
          _field(_bio, 'About / bio', maxLines: 4),
          const SizedBox(height: HealynSpacing.s5),
          const HealynSectionHeader(title: 'Clinic details'),
          const SizedBox(height: HealynSpacing.s3),
          _field(_clinicName, 'Clinic name'),
          _field(_clinicAddress, 'Clinic address', maxLines: 3),
          _field(
            _clinicPhone,
            'Clinic contact number',
            keyboardType: TextInputType.phone,
          ),
          _field(_clinicDescription, 'Clinic description', maxLines: 4),
          const SizedBox(height: HealynSpacing.s5),
          const HealynSectionHeader(title: 'Social links'),
          const SizedBox(height: HealynSpacing.s3),
          _urlField(_instagram, 'Instagram URL'),
          _urlField(_facebook, 'Facebook URL'),
          _urlField(_linkedin, 'LinkedIn URL'),
          _urlField(_website, 'Website URL'),
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
                : const Text('Save profile'),
          ),
          const SizedBox(height: HealynSpacing.s8),
        ],
      ),
    );
  }

  Widget _avatarRow() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              children: [
                _PhysioAvatar(
                  url: _avatarUrl,
                  name: _displayName.text.isEmpty
                      ? 'Physiotherapist'
                      : _displayName.text,
                  size: 96,
                ),
                if (_uploadingAvatar)
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: HealynSpacing.s2),
          TextButton.icon(
            onPressed: _uploadingAvatar ? null : _pickAvatar,
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(_avatarUrl == null ? 'Add photo' : 'Change photo'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HealynSpacing.s3),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _urlField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HealynSpacing.s3),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.url,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _validateUrl,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'https://…',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// A circular avatar that shows the physiotherapist's photo when [url] is set,
/// falling back to the deterministic initials avatar.
class _PhysioAvatar extends StatelessWidget {
  const _PhysioAvatar({required this.url, required this.name, this.size = 56});

  final String? url;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return HealynAvatar(name: name, size: size);
    }
    return ClipOval(
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => HealynAvatar(name: name, size: size),
      ),
    );
  }
}
