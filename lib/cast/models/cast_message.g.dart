// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CastMessage _$CastMessageFromJson(Map<String, dynamic> json) {
  return CastMessage(
      _$enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      json['routine'] == null
          ? null
          : Routine.fromJson(json['routine'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CastMessageToJson(CastMessage instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type],
      'routine': instance.routine
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$MessageTypeEnumMap = <MessageType, dynamic>{
  MessageType.LOAD: 'LOAD',
  MessageType.PLAY: 'PLAY',
  MessageType.PAUSE: 'PAUSE',
  MessageType.STOP: 'STOP'
};
