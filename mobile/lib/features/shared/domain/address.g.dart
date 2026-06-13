// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  line1: json['line1'] as String,
  line2: json['line2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  postalCode: json['postal_code'] as String,
  country: json['country'] as String? ?? 'India',
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'line1': instance.line1,
  'line2': ?instance.line2,
  'city': instance.city,
  'state': instance.state,
  'postal_code': instance.postalCode,
  'country': instance.country,
};
