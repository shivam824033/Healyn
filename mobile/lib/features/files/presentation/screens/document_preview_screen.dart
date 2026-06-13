import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../data/files_repository.dart';
import '../../data/url_opener.dart';
import '../documents_format.dart';

/// In-app preview of a document. Fetches the file's bytes into memory (never to
/// disk) and renders a PDF with `pdfx` (`PdfDocument.openData`) or an image with
/// a zoomable [InteractiveViewer]. The buffer is released on dispose. An app-bar
/// action falls back to the device's default viewer via a fresh presigned URL.
class DocumentPreviewScreen extends ConsumerStatefulWidget {
  const DocumentPreviewScreen({
    required this.fileId,
    required this.filename,
    required this.mimeType,
    super.key,
  });

  final String fileId;
  final String filename;
  final String mimeType;

  @override
  ConsumerState<DocumentPreviewScreen> createState() =>
      _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends ConsumerState<DocumentPreviewScreen> {
  Uint8List? _bytes;
  PdfControllerPinch? _pdf;
  String? _error;
  bool _loading = true;

  bool get _isPdf => isPdfMime(widget.mimeType);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pdf?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bytes = await ref
          .read(filesRepositoryProvider)
          .previewBytes(widget.fileId);
      if (!mounted) return;
      setState(() {
        _bytes = bytes;
        if (_isPdf) {
          _pdf = PdfControllerPinch(document: PdfDocument.openData(bytes));
        }
        _loading = false;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _openExternally() async {
    try {
      final target = await ref
          .read(filesRepositoryProvider)
          .download(widget.fileId);
      final opened = await ref.read(urlOpenerProvider).open(target.url);
      if (!opened && mounted) {
        _toast("Couldn't open this document.");
      }
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: widget.filename,
        actions: [
          IconButton(
            tooltip: 'Open in another app',
            icon: const Icon(Icons.open_in_new),
            onPressed: _openExternally,
          ),
        ],
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(HealynSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ErrorBanner(message: _error!),
              const SizedBox(height: HealynSpacing.s4),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (_isPdf && _pdf != null) {
      return PdfViewPinch(controller: _pdf!);
    }
    final bytes = _bytes;
    if (bytes != null) {
      return InteractiveViewer(
        maxScale: 5,
        child: Center(child: Image.memory(bytes)),
      );
    }
    return const SizedBox.shrink();
  }
}
