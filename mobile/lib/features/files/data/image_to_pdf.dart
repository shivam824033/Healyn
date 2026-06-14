import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'file_picker_service.dart';

/// Merges [images] into a single PDF — one image per A4 page, fit to the page —
/// entirely in memory. The returned bytes are PUT straight to storage; nothing
/// is written to disk. Callers convert only when there are two or more images; a
/// single image is uploaded as-is (FILE_STORAGE_GUIDELINES §9). Images are
/// expected to be JPEG/PNG (what the gallery/camera return); other encodings are
/// rejected by the picker upstream.
Future<Uint8List> imagesToPdf(List<PickedFile> images) async {
  final doc = pw.Document();
  for (final image in images) {
    final memory = pw.MemoryImage(Uint8List.fromList(image.bytes));
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (context) =>
            pw.Center(child: pw.Image(memory, fit: pw.BoxFit.contain)),
      ),
    );
  }
  return doc.save();
}

/// Runs [imagesToPdf] on a background isolate via [compute]. Decoding several
/// photos and serializing the PDF is CPU-heavy and would freeze the UI mid-upload;
/// the screen keeps its progress spinner visible while this runs off the main
/// isolate. [PickedFile] is a plain data holder, so it copies across the isolate
/// boundary cleanly.
Future<Uint8List> imagesToPdfInBackground(List<PickedFile> images) =>
    compute(imagesToPdf, images);
