import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_models.freezed.dart';
part 'appointment_models.g.dart';

/// Lifecycle of an appointment. Wire values are the backend enum names. The
/// patient app can drive only a subset of transitions (it may cancel); the
/// physiotherapist confirms, starts, completes, and marks no-shows.
enum AppointmentStatus {
  @JsonValue('REQUESTED')
  requested,
  @JsonValue('CONFIRMED')
  confirmed,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('NO_SHOW')
  noShow,
  @JsonValue('RESCHEDULED')
  rescheduled,
}

extension AppointmentStatusX on AppointmentStatus {
  String get label => switch (this) {
    AppointmentStatus.requested => 'Requested',
    AppointmentStatus.confirmed => 'Confirmed',
    AppointmentStatus.inProgress => 'In progress',
    AppointmentStatus.completed => 'Completed',
    AppointmentStatus.cancelled => 'Cancelled',
    AppointmentStatus.noShow => 'No-show',
    AppointmentStatus.rescheduled => 'Rescheduled',
  };

  /// Still open on the calendar — shown under "Upcoming".
  bool get isActive =>
      this == AppointmentStatus.requested ||
      this == AppointmentStatus.confirmed ||
      this == AppointmentStatus.inProgress;

  /// The patient (or a family manager) may cancel only before it starts.
  bool get isCancellableByPatient =>
      this == AppointmentStatus.requested ||
      this == AppointmentStatus.confirmed;
}

/// Why an appointment was cancelled. The patient app only ever sends
/// [patientCancelled]; the others originate physio- or clinic-side.
enum AppointmentCancelReason {
  @JsonValue('PATIENT_CANCELLED')
  patientCancelled,
  @JsonValue('PHYSIO_CANCELLED')
  physioCancelled,
  @JsonValue('CLINIC_CLOSED')
  clinicClosed,
  @JsonValue('OTHER')
  other,
}

extension AppointmentCancelReasonLabel on AppointmentCancelReason {
  String get label => switch (this) {
    AppointmentCancelReason.patientCancelled => 'Cancelled by patient',
    AppointmentCancelReason.physioCancelled => 'Cancelled by physiotherapist',
    AppointmentCancelReason.clinicClosed => 'Clinic closed',
    AppointmentCancelReason.other => 'Cancelled',
  };
}

/// A single appointment. Mirrors the backend `AppointmentView`. Timestamps are
/// instants (UTC on the wire); call `.toLocal()` before formatting for display.
/// [reason] is free text the patient gave — not clinical, but don't log it.
@freezed
abstract class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String patientId,
    required String bookedByAccountId,
    required String physiotherapistId,
    required DateTime scheduledAt,
    required DateTime scheduledEndAt,
    required int durationMinutes,
    required AppointmentStatus status,
    String? reason,
    AppointmentCancelReason? cancelReason,
    String? cancelNote,
    String? rescheduledFromId,
    DateTime? confirmedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}

/// One cursor page of appointments. [nextCursor] is null on the last page.
@freezed
abstract class AppointmentPage with _$AppointmentPage {
  const factory AppointmentPage({
    required List<Appointment> items,
    String? nextCursor,
  }) = _AppointmentPage;

  factory AppointmentPage.fromJson(Map<String, dynamic> json) =>
      _$AppointmentPageFromJson(json);
}

/// Body for `POST /appointments`. [scheduledAt] must be the exact `startsAt` of
/// an available [Slot] and [durationMinutes] its duration — the backend rejects
/// anything that isn't a live slot. [reason] is optional (omitted when null).
@freezed
abstract class BookAppointmentRequest with _$BookAppointmentRequest {
  const factory BookAppointmentRequest({
    required String patientId,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? reason,
  }) = _BookAppointmentRequest;

  factory BookAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$BookAppointmentRequestFromJson(json);
}

/// Body for `POST /appointments/{id}/transitions`. The patient app uses this
/// only to cancel: [to] is [AppointmentStatus.cancelled] with a [cancelReason].
@freezed
abstract class TransitionRequest with _$TransitionRequest {
  const factory TransitionRequest({
    required AppointmentStatus to,
    AppointmentCancelReason? cancelReason,
    String? cancelNote,
  }) = _TransitionRequest;

  factory TransitionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransitionRequestFromJson(json);
}

/// A bookable time window for the physiotherapist. Computed server-side from
/// availability rules minus blackouts and already-booked appointments — never a
/// stored row. [startsAt]/[endsAt] are instants (UTC on the wire).
@freezed
abstract class Slot with _$Slot {
  const factory Slot({
    required DateTime startsAt,
    required DateTime endsAt,
    required int durationMinutes,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}

/// Response of `GET /availability` — the resolved physiotherapist and their
/// open slots over the requested range.
@freezed
abstract class SlotListResponse with _$SlotListResponse {
  const factory SlotListResponse({
    required String physiotherapistId,
    required List<Slot> slots,
  }) = _SlotListResponse;

  factory SlotListResponse.fromJson(Map<String, dynamic> json) =>
      _$SlotListResponseFromJson(json);
}
