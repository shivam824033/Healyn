import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/files/data/file_types.dart';

// "%PDF-1.7" followed by arbitrary content.
const _pdfBytes = [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x37, 0x0A, 0x00];
// "PK" — a zip/docx, mislabelled as .pdf by a hostile or careless client.
const _zipBytes = [0x50, 0x4B, 0x03, 0x04, 0x00];

void main() {
  group('hasPdfMagic', () {
    test('accepts bytes that start with the %PDF- signature', () {
      expect(hasPdfMagic(_pdfBytes), isTrue);
    });

    test('rejects a non-PDF payload even with a .pdf name upstream', () {
      expect(hasPdfMagic(_zipBytes), isFalse);
    });

    test('rejects empty and too-short input', () {
      expect(hasPdfMagic(const []), isFalse);
      expect(hasPdfMagic(const [0x25, 0x50]), isFalse);
    });
  });

  group('uploadTypeForFilename', () {
    test('resolves accepted extensions to their MIME + cap', () {
      expect(uploadTypeForFilename('mri.pdf')?.mimeType, 'application/pdf');
      expect(uploadTypeForFilename('scan.JPG')?.mimeType, 'image/jpeg');
      expect(uploadTypeForFilename('x.png')?.maxBytes, 10 * 1024 * 1024);
    });

    test('rejects unsupported or extension-less names', () {
      expect(uploadTypeForFilename('report.docx'), isNull);
      expect(uploadTypeForFilename('noext'), isNull);
    });
  });

  test('maxImagesPerUpload is a sane positive bound', () {
    expect(maxImagesPerUpload, greaterThan(0));
    expect(maxImagesPerUpload, lessThanOrEqualTo(50));
  });
}
