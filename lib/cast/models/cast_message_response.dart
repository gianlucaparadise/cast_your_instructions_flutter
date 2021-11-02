import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../models/routine.dart';

part 'cast_message_response.g.dart';

@JsonSerializable()
class CastMessageResponse {
  ResponseMessageType? type;
  Routine? routine;
  int? selectedInstructionIndex;

  CastMessageResponse({this.type, this.routine, this.selectedInstructionIndex});

  factory CastMessageResponse.fromJsonString(String jsonString) =>
      CastMessageResponse.fromJson(jsonDecode(jsonString));

  factory CastMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$CastMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CastMessageResponseToJson(this);
}

enum ResponseMessageType {
  IDLE,
  LOADED,
  PLAYED,
  PAUSED,
  STOPPED,
  SELECTED_INSTRUCTION,
}
