
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../models/routine.dart';

part 'cast_message.g.dart';

@JsonSerializable()
class CastMessage {
  MessageType type;
  Routine routine;

  CastMessage(this.type, [this.routine]);

  factory CastMessage.fromJson(Map<String, dynamic> json) =>
      _$CastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CastMessageToJson(this);

  String toJsonString() => jsonEncode(toJson());
}

enum MessageType {
  LOAD,
  PLAY,
  PAUSE,
  STOP,
}
