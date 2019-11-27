// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instruction _$InstructionFromJson(Map<String, dynamic> json) {
  return Instruction(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      countdown: json['countdown'] as int,
      videoUrl: json['videoUrl'] as String);
}

Map<String, dynamic> _$InstructionToJson(Instruction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'countdown': instance.countdown,
      'videoUrl': instance.videoUrl
    };

Routine _$RoutineFromJson(Map<String, dynamic> json) {
  return Routine(
      id: json['id'] as int,
      title: json['title'] as String,
      source: json['source'] as String,
      instructions: (json['instructions'] as List)
          ?.map((e) => e == null
              ? null
              : Instruction.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'source': instance.source,
      'instructions': instance.instructions
    };

RoutineList _$RoutineListFromJson(Map<String, dynamic> json) {
  return RoutineList(
      routines: (json['routines'] as List)
          ?.map((e) =>
              e == null ? null : Routine.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$RoutineListToJson(RoutineList instance) =>
    <String, dynamic>{'routines': instance.routines};
