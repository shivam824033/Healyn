import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/network/json_converters.dart';

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

  /// The patient may move a still-open appointment to a new time. Mirrors the
  /// backend reschedule precondition (REQUESTED or CONFIRMED only).
  bool get isReschedulableByPatient =>
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

/// How an appointment derived from its lineage root (null on a root booking). Only actions
/// that spawn a new bookable row are children: a reschedule replacement or a follow-up tied
/// to a prior appointment. Mirrors the backend `AppointmentChildKind`.
enum AppointmentChildKind {
  @JsonValue('RESCHEDULE')
  reschedule,
  @JsonValue('FOLLOW_UP')
  followUp,
  @JsonValue('REVIEW')
  review,
  @JsonValue('REOPEN')
  reopen,
}

extension AppointmentChildKindLabel on AppointmentChildKind {
  String get label => switch (this) {
    AppointmentChildKind.reschedule => 'Rescheduled',
    AppointmentChildKind.followUp => 'Follow-up',
    AppointmentChildKind.review => 'Review',
    AppointmentChildKind.reopen => 'Reopened',
  };
}

/// A single appointment. Mirrors the backend `AppointmentView`.
///
/// [appointmentNumber] is the human-friendly business id (e.g. `PHY-20260610-0001`)
/// shown on cards, detail and search; [id] is the internal UUID and is never displayed.
/// Optional only for resilience to older cached payloads — the backend always sends it.
///
/// Request-first: the patient submits a [requestedDate] (mandatory) and an
/// optional [preferredTime] hint; the physiotherapist later assigns the final
/// time. Until they do, [scheduledAt]/[scheduledEndAt] are null and the status
/// is `requested` — use [isScheduled] / [day] rather than reading [scheduledAt]
/// blindly. Instants are UTC on the wire; call `.toLocal()` before formatting.
/// [requestedDate] is a bare local calendar day; [preferredTime] is a wire
/// `HH:mm[:ss]` clock string. [reason] is free text the patient gave — not
/// clinical, but don't log it.
@freezed
abstract class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    String? appointmentNumber,
    required String patientId,
    required String bookedByAccountId,
    required String physiotherapistId,
    @LocalDateConverter() required DateTime requestedDate,
    String? preferredTime,
    DateTime? scheduledAt,
    DateTime? scheduledEndAt,
    required int durationMinutes,
    required AppointmentStatus status,
    @Default(false) bool isFollowUp,
    String? reason,
    AppointmentCancelReason? cancelReason,
    String? cancelNote,
    String? rescheduledFromId,
    // Lineage: [rootAppointmentId] is the origin of the chain (equals [id] on a root);
    // [sourceAppointmentId] is the immediate appointment this one derived from; [childKind]
    // is how (null on a root). The richer timeline view is built on these in a later chunk.
    String? rootAppointmentId,
    String? sourceAppointmentId,
    AppointmentChildKind? childKind,
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

extension AppointmentX on Appointment {
  /// True once the physiotherapist has assigned a final time. Until then the
  /// appointment is a bare request: only [Appointment.requestedDate] (and an
  /// optional [Appointment.preferredTime]) is set and [Appointment.scheduledAt]
  /// is null.
  bool get isScheduled => scheduledAt != null;

  /// The day to show for the appointment whatever its status: the confirmed
  /// instant once scheduled, otherwise the requested calendar day. Never null,
  /// so list/sort code can rely on it. (A scheduled instant is UTC; a requested
  /// date is already local midnight — both render correctly via `.toLocal()`.)
  DateTime get day => scheduledAt ?? requestedDate;
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

/// Body for `POST /appointments` — a patient request. [requestedDate] (a bare
/// calendar day) is mandatory; [preferredTime] is an optional `HH:mm:ss` hint.
/// The patient never sends a final time — the physiotherapist assigns it later.
/// [preferredTime] / [reason] are omitted when null (`include_if_null:false`).
@freezed
abstract class BookAppointmentRequest with _$BookAppointmentRequest {
  const factory BookAppointmentRequest({
    required String patientId,
    @LocalDateConverter() required DateTime requestedDate,
    String? preferredTime,
    String? reason,
  }) = _BookAppointmentRequest;

  factory BookAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$BookAppointmentRequestFromJson(json);
}

/// Body for `POST /appointments/{id}/reschedule` from the patient side — a
/// re-request, not a self-assigned time. The patient picks a new [requestedDate]
/// (mandatory) and an optional [preferredTime] hint; the backend keeps the same
/// patient and physiotherapist, marks the old appointment RESCHEDULED, and
/// returns a fresh unscheduled REQUESTED one for the physiotherapist to schedule.
/// A null [reason] keeps the original appointment's reason. No Idempotency-Key
/// (the source appointment id makes it idempotent).
@freezed
abstract class RescheduleAppointmentRequest with _$RescheduleAppointmentRequest {
  const factory RescheduleAppointmentRequest({
    @LocalDateConverter() required DateTime requestedDate,
    String? preferredTime,
    String? reason,
  }) = _RescheduleAppointmentRequest;

  factory RescheduleAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$RescheduleAppointmentRequestFromJson(json);
}

/// Body for `POST /appointments/{id}/schedule` — the physiotherapist assigns the
/// final time to a REQUESTED appointment, moving it to CONFIRMED. [scheduledAt]
/// is a UTC instant (built from the picked local date + time); [durationMinutes]
/// is 5–240.
@freezed
abstract class ScheduleAppointmentRequest with _$ScheduleAppointmentRequest {
  const factory ScheduleAppointmentRequest({
    @UtcInstantConverter() required DateTime scheduledAt,
    required int durationMinutes,
  }) = _ScheduleAppointmentRequest;

  factory ScheduleAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleAppointmentRequestFromJson(json);
}

/// Body for `POST /appointments/follow-ups` — the physiotherapist books a
/// follow-up review for [patientId] at a time they set (a new CONFIRMED row,
/// `is_follow_up=true`). [reason] is optional and omitted when null.
@freezed
abstract class FollowUpRequest with _$FollowUpRequest {
  const factory FollowUpRequest({
    required String patientId,
    @UtcInstantConverter() required DateTime scheduledAt,
    required int durationMinutes,
    String? reason,
  }) = _FollowUpRequest;

  factory FollowUpRequest.fromJson(Map<String, dynamic> json) =>
      _$FollowUpRequestFromJson(json);
}

/// Body for `POST /appointments/{id}/reschedule` from the physiotherapist side —
/// they assign the new final time directly (a new CONFIRMED row; the original is
/// marked RESCHEDULED). Distinct from the patient's [RescheduleAppointmentRequest],
/// which is a re-request with no self-assigned time. A null [reason] keeps the
/// original appointment's reason.
@freezed
abstract class PhysioRescheduleRequest with _$PhysioRescheduleRequest {
  const factory PhysioRescheduleRequest({
    @UtcInstantConverter() required DateTime scheduledAt,
    required int durationMinutes,
    String? reason,
  }) = _PhysioRescheduleRequest;

  factory PhysioRescheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$PhysioRescheduleRequestFromJson(json);
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
