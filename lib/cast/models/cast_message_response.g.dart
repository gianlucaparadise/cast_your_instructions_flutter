// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CastMessageResponse _$CastMessageResponseFromJson(Map<String, dynamic> json) {
  return CastMessageResponse(
      type: _$enumDecodeNullable(_$ResponseMessageTypeEnumMap, json['type']),
      routine: json['routine'] == null
          ? null
          : Routine.fromJson(json['routine'] as Map<String, dynamic>),
      selectedInstructionIndex: json['selectedInstructionIndex'] as int);
}

Map<String, dynamic> _$CastMessageResponseToJson(
        CastMessageResponse instance) =>
    <String, dynamic>{
      'type': _$ResponseMessageTypeEnumMap[instance.type],
      'routine': instance.routine,
      'selectedInstructionIndex': instance.selectedInstructionIndex
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

const _$ResponseMessageTypeEnumMap = <ResponseMessageType, dynamic>{
  ResponseMessageType.LOADED: 'LOADED',
  ResponseMessageType.PLAYED: 'PLAYED',
  ResponseMessageType.PAUSED: 'PAUSED',
  ResponseMessageType.STOPPED: 'STOPPED',
  ResponseMessageType.SELECTED_INSTRUCTION: 'SELECTED_INSTRUCTION'
};
