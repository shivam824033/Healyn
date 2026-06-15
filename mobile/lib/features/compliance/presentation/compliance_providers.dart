import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/compliance_repository.dart';
import '../data/models/compliance_models.dart';

/// Fetches a legal document by its path segment (e.g. `privacy_policy`). Public —
/// usable while unauthenticated (the registration consent links).
final legalDocumentProvider =
    FutureProvider.autoDispose.family<LegalDocument, String>(
  (ref, kindPath) =>
      ref.watch(complianceRepositoryProvider).legalDocument(kindPath),
);

/// The account's consent history, with grant/withdraw. A change refetches the
/// full list so the screen reflects the server's record.
class ConsentsController
    extends AutoDisposeAsyncNotifier<List<ConsentView>> {
  @override
  Future<List<ConsentView>> build() {
    return ref.watch(complianceRepositoryProvider).consents();
  }

  Future<void> setGranted(ConsentType type, bool granted) async {
    await ref
        .read(complianceRepositoryProvider)
        .recordConsent(type, granted: granted);
    ref.invalidateSelf();
    await future;
  }
}

final consentsControllerProvider =
    AutoDisposeAsyncNotifierProvider<ConsentsController, List<ConsentView>>(
  ConsentsController.new,
);

/// The account's active deletion request (null when none), with open/cancel.
class DeletionRequestController
    extends AutoDisposeAsyncNotifier<DeletionRequestView?> {
  @override
  Future<DeletionRequestView?> build() {
    return ref.watch(complianceRepositoryProvider).deletionRequest();
  }

  Future<DeletionRequestView> request({
    required String password,
    String? reason,
  }) async {
    final view = await ref
        .read(complianceRepositoryProvider)
        .requestDeletion(password: password, reason: reason);
    state = AsyncData(view);
    return view;
  }

  Future<void> cancel() async {
    await ref.read(complianceRepositoryProvider).cancelDeletion();
    state = const AsyncData(null);
  }
}

final deletionRequestControllerProvider = AutoDisposeAsyncNotifierProvider<
    DeletionRequestController, DeletionRequestView?>(
  DeletionRequestController.new,
);
