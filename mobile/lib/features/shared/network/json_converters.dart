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
