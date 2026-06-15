import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/compliance/data/models/compliance_models.dart';

void main() {
  test('LegalDocument parses the snake_case envelope', () {
    final doc = LegalDocument.fromJson({
      'kind': 'PRIVACY_POLICY',
      'version': '2026-06-14',
      'locale': 'en',
      'title': 'Privacy Policy',
      'body_markdown': 'DRAFT — PENDING LEGAL REVIEW',
      'effective_at': '2026-06-14T00:00:00Z',
    });

    expect(doc.kind, 'PRIVACY_POLICY');
    expect(doc.version, '2026-06-14');
    expect(doc.title, 'Privacy Policy');
    expect(doc.bodyMarkdown, 'DRAFT — PENDING LEGAL REVIEW');
    expect(doc.effectiveAt, DateTime.utc(2026, 6, 14));
  });

  test('ConsentView maps consent_type to the enum and reads timestamps', () {
    final view = ConsentView.fromJson({
      'id': 'c1',
      'consent_type': 'HEALTH_DATA_PROCESSING',
      'patient_id': null,
      'granted': true,
      'document_version': '2026-06-14',
      'granted_at': '2026-06-14T10:00:00Z',
      'withdrawn_at': null,
    });

    expect(view.consentType, ConsentType.healthDataProcessing);
    expect(view.granted, isTrue);
    expect(view.documentVersion, '2026-06-14');
    expect(view.grantedAt, DateTime.utc(2026, 6, 14, 10));
    expect(view.withdrawnAt, isNull);
  });

  test('ConsentListResponse defaults to an empty list', () {
    final empty = ConsentListResponse.fromJson({'consents': <dynamic>[]});
    expect(empty.consents, isEmpty);
  });

  test('DeletionRequestView carries status and the grace window', () {
    final view = DeletionRequestView.fromJson({
      'status': 'REQUESTED',
      'requested_at': '2026-06-14T10:00:00Z',
      'purge_after': '2026-07-14T10:00:00Z',
    });

    expect(view.status, 'REQUESTED');
    expect(view.requestedAt, DateTime.utc(2026, 6, 14, 10));
    expect(view.purgeAfter, DateTime.utc(2026, 7, 14, 10));
  });

  test('LegalDocumentKind resolves a path segment', () {
    expect(LegalDocumentKind.fromPath('privacy_policy'),
        LegalDocumentKind.privacyPolicy);
    expect(LegalDocumentKind.fromPath('terms_of_service'),
        LegalDocumentKind.termsOfService);
    expect(LegalDocumentKind.fromPath('nope'), isNull);
  });
}
