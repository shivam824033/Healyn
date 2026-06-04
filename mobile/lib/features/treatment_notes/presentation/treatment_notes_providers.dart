import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/treatment_note_models.dart';
import '../data/treatment_notes_repository.dart';

/// The treatment note for a given appointment id, or `null` when the physio
/// hasn't written one yet. Keyed by appointment id so each detail screen reads
/// its own; auto-disposed when the screen leaves.
final treatmentNoteForAppointmentProvider =
    FutureProvider.autoDispose.family<TreatmentNote?, String>(
  (ref, appointmentId) =>
      ref.watch(treatmentNotesRepositoryProvider).forAppointment(appointmentId),
);
