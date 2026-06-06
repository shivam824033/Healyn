import '../../appointments/data/models/appointment_models.dart';

/// A transition a physiotherapist can drive from the appointment detail screen.
/// Each action maps to a target [AppointmentStatus]; the [isCancellation]
/// actions (Reject / Cancel) collect a mandatory note before they fire, per the
/// cancellation policy in APPOINTMENT_FLOW §7. Confirming a request is *not* a
/// plain transition (request-first: the physiotherapist assigns a time via
/// `POST /{id}/schedule`), so it lives in the assign-time sheet, not here.
enum PhysioAppointmentAction {
  reject,
  start,
  complete,
  noShow,
  cancel;

  String get label => switch (this) {
    PhysioAppointmentAction.reject => 'Reject',
    PhysioAppointmentAction.start => 'Start session',
    PhysioAppointmentAction.complete => 'Mark completed',
    PhysioAppointmentAction.noShow => 'Mark no-show',
    PhysioAppointmentAction.cancel => 'Cancel appointment',
  };

  /// The status this action transitions the appointment to.
  AppointmentStatus get target => switch (this) {
    PhysioAppointmentAction.reject ||
    PhysioAppointmentAction.cancel => AppointmentStatus.cancelled,
    PhysioAppointmentAction.start => AppointmentStatus.inProgress,
    PhysioAppointmentAction.complete => AppointmentStatus.completed,
    PhysioAppointmentAction.noShow => AppointmentStatus.noShow,
  };

  /// Whether this action cancels the appointment, which requires a note (the
  /// physio must always say why) and a cancel reason.
  bool get isCancellation =>
      this == PhysioAppointmentAction.reject ||
      this == PhysioAppointmentAction.cancel;

  /// Start / Mark-completed are the forward, non-destructive actions shown as
  /// the filled primary button; the rest are outlined.
  bool get isPrimary =>
      this == PhysioAppointmentAction.start ||
      this == PhysioAppointmentAction.complete;
}

/// The transitions a physiotherapist may drive from [status], in display order,
/// mirroring the allowed-transition matrix in APPOINTMENT_FLOW §3.1. A REQUESTED
/// appointment offers only Reject here — confirming it means assigning a time
/// (the assign-time sheet, not a transition). Terminal statuses offer none.
List<PhysioAppointmentAction> physioActionsFor(AppointmentStatus status) =>
    switch (status) {
      AppointmentStatus.requested => const [
        PhysioAppointmentAction.reject,
      ],
      AppointmentStatus.confirmed => const [
        PhysioAppointmentAction.start,
        PhysioAppointmentAction.noShow,
        PhysioAppointmentAction.cancel,
      ],
      AppointmentStatus.inProgress => const [
        PhysioAppointmentAction.complete,
        PhysioAppointmentAction.cancel,
      ],
      AppointmentStatus.completed ||
      AppointmentStatus.cancelled ||
      AppointmentStatus.noShow ||
      AppointmentStatus.rescheduled => const [],
    };

/// The cancel reason the physio app sends for a cancellation from [from]. An
/// in-progress cancellation is the rare emergency case (OTHER); otherwise it is
/// a physiotherapist-initiated cancellation (APPOINTMENT_FLOW §3.1).
AppointmentCancelReason physioCancelReasonFor(AppointmentStatus from) =>
    from == AppointmentStatus.inProgress
    ? AppointmentCancelReason.other
    : AppointmentCancelReason.physioCancelled;
