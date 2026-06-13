import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/physio/presentation/physio_upcoming_providers.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';

Appointment _appt(String id, AppointmentStatus status) => Appointment(
  id: id,
  patientId: 'p1',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(2026, 6, 1),
  scheduledAt: DateTime(2026, 6, 1, 9),
  durationMinutes: 45,
  status: status,
);

class _FixedPhysioAppointments extends PhysioAppointmentsNotifier {
  _FixedPhysioAppointments(this._items);

  final List<Appointment> _items;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _items, hasMore: false);
}

/// Records which appointment ids were asked about and reports [withNotes] as the
/// ones that have a note.
class _RecordingNotesRepo extends TreatmentNotesRepository {
  _RecordingNotesRepo(this.withNotes) : super(TreatmentNotesApi(Dio()));

  final Set<String> withNotes;
  List<String>? asked;

  @override
  Future<Set<String>> appointmentsWithNotes(List<String> ids) async {
    asked = ids;
    return ids.where(withNotes.contains).toSet();
  }
}

ProviderContainer _container({
  required List<Appointment> appointments,
  required _RecordingNotesRepo repo,
}) {
  final c = ProviderContainer(
    overrides: [
      physioAppointmentsProvider.overrideWith(
        () => _FixedPhysioAppointments(appointments),
      ),
      treatmentNotesRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('asks only about completed appointments and returns the noted ones', () async {
    final repo = _RecordingNotesRepo({'a1'});
    final c = _container(
      appointments: [
        _appt('a1', AppointmentStatus.completed), // has a note
        _appt('a2', AppointmentStatus.completed), // no note
        _appt('a3', AppointmentStatus.confirmed), // not completed → not asked
      ],
      repo: repo,
    );

    final result = await c.read(physioNoteStatusProvider.future);

    expect(result, {'a1'});
    expect(repo.asked, containsAll(<String>['a1', 'a2']));
    expect(repo.asked, isNot(contains('a3')));
  });

  test('returns empty without a call when nothing is completed', () async {
    final repo = _RecordingNotesRepo(const {});
    final c = _container(
      appointments: [_appt('a3', AppointmentStatus.confirmed)],
      repo: repo,
    );

    final result = await c.read(physioNoteStatusProvider.future);

    expect(result, isEmpty);
    expect(repo.asked, isNull); // no completed ids → no round-trip
  });
}
