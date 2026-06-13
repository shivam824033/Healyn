import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

/// A household postal address, captured at signup and shared across every
/// patient on the account. Mirrors the backend `AddressView` / `AddressRequest`
/// (snake_case JSON via build.yaml: `postalCode` ↔ `postal_code`).
///
/// Shared between the auth (registration) and patients features, so it lives in
/// `shared/domain` rather than in either feature.
@freezed
abstract class Address with _$Address {
  const factory Address({
    required String line1,
    String? line2,
    required String city,
    required String state,
    required String postalCode,
    @Default('India') String country,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

extension AddressFormat on Address {
  /// The address as display lines (line2 dropped when empty), e.g.
  /// `["12 MG Road", "Apt 4", "Pune, Maharashtra 411001", "India"]`.
  List<String> get displayLines => [
    line1,
    if (line2 != null && line2!.trim().isNotEmpty) line2!.trim(),
    '$city, $state $postalCode',
    country,
  ];

  /// A one-line summary for compact rows.
  String get singleLine => displayLines.join(', ');
}
