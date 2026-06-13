import 'package:freezed_annotation/freezed_annotation.dart';

/// Serializes a [DateTime] as a bare `yyyy-MM-dd` date to match the backend's
/// `LocalDate` (a date of birth carries no time-of-day). Shared by any model
/// with a date-only field.
class LocalDateConverter implements JsonConverter<DateTime, String> {
  const LocalDateConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) =>
      '${object.year.toString().padLeft(4, '0')}-'
      '${object.month.toString().padLeft(2, '0')}-'
      '${object.day.toString().padLeft(2, '0')}';
}

/// Serializes a [DateTime] as a UTC ISO-8601 instant (with a trailing `Z`) to
/// match the backend's `Instant`. A local DateTime is converted to UTC first, so
/// callers can build the instant in local time (e.g. a picked date + time) and
/// the wire value is always unambiguous.
class UtcInstantConverter implements JsonConverter<DateTime, String> {
  const UtcInstantConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toUtc();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
