import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/files/data/models/file_models.dart';

void main() {
  test('PresignRequest serializes to snake_case with enum wire values', () {
    final json = const PresignRequest(
      patientId: 'p1',
      appointmentId: 'ap1',
      kind: FileKind.report,
      mimeType: 'application/pdf',
      sizeBytes: 1024,
      originalFilename: 'spine.pdf',
    ).toJson();

    expect(json['patient_id'], 'p1');
    expect(json['appointment_id'], 'ap1');
    expect(json['kind'], 'REPORT');
    expect(json['mime_type'], 'application/pdf');
    expect(json['size_bytes'], 1024);
    expect(json['original_filename'], 'spine.pdf');
  });

  test('PresignResponse parses the nested upload target and headers', () {
    final res = PresignResponse.fromJson(<String, dynamic>{
      'file_id': 'f1',
      'upload': {
        'method': 'PUT',
        'url': 'https://store.example/x?sig=abc',
        'headers': {'Content-Type': 'application/pdf'},
        'expires_in_seconds': 300,
      },
    });

    expect(res.fileId, 'f1');
    expect(res.upload.method, 'PUT');
    expect(res.upload.url, 'https://store.example/x?sig=abc');
    expect(res.upload.headers['Content-Type'], 'application/pdf');
    expect(res.upload.expiresInSeconds, 300);
  });

  test('FileObjectView parses kind/status enums and timestamps', () {
    final v = FileObjectView.fromJson(<String, dynamic>{
      'id': 'f1',
      'patient_id': 'p1',
      'owner_account_id': 'a1',
      'kind': 'XRAY',
      'mime_type': 'image/png',
      'original_filename': 'knee.png',
      'size_bytes': 2048,
      'status': 'AVAILABLE',
      'created_at': '2026-06-10T11:00:00Z',
      'available_at': '2026-06-10T11:00:05Z',
    });

    expect(v.kind, FileKind.xray);
    expect(v.status, FileStatus.available);
    expect(v.sizeBytes, 2048);
    expect(v.availableAt!.toUtc(), DateTime.utc(2026, 6, 10, 11, 0, 5));
  });
}
