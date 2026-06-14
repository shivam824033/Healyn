import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/files/data/file_picker_service.dart';
import 'package:healyn/features/files/data/image_to_pdf.dart';
import 'package:image/image.dart' as img;

/// A small, valid PNG so `pw.MemoryImage` can decode it.
Uint8List _png(int color) {
  final image = img.Image(width: 8, height: 8);
  img.fill(image, color: img.ColorRgb8(color, 0, 0));
  return img.encodePng(image);
}

// `%PDF-` — the PDF magic bytes the backend validator also checks.
const _pdfMagic = [0x25, 0x50, 0x44, 0x46, 0x2D];

void main() {
  test('merges multiple images into one valid PDF', () async {
    final images = [
      PickedFile(bytes: _png(200), filename: 'page1.png'),
      PickedFile(bytes: _png(100), filename: 'page2.png'),
      PickedFile(bytes: _png(50), filename: 'page3.png'),
    ];

    final pdf = await imagesToPdf(images);

    expect(pdf.sublist(0, 5), _pdfMagic);
    expect(pdf.length, greaterThan(100));
  });

  test('produces a valid PDF for a single image too', () async {
    final pdf = await imagesToPdf([
      PickedFile(bytes: _png(255), filename: 'only.png'),
    ]);

    expect(pdf.sublist(0, 5), _pdfMagic);
  });
}
