import 'package:flutter/material.dart';

import '../features/shared/design/theme.dart';
import 'refined_indigo_gallery.dart';

/// Throwaway entrypoint to preview the Refined Indigo kit in isolation, themed
/// exactly like the app but without its router/providers:
///
///   flutter run -t lib/dev/gallery_main.dart
///
/// Delete this (and refined_indigo_gallery.dart) once the kit is signed off.
void main() {
  runApp(
    MaterialApp(
      title: 'Refined Indigo — Gallery',
      debugShowCheckedModeBanner: false,
      theme: HealynTheme.light(),
      home: const RefinedIndigoGallery(),
    ),
  );
}
