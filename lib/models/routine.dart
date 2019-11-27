import 'package:json_annotation/json_annotation.dart';

part 'routine.g.dart';

@JsonSerializable()
class Instruction {
  int id;
  String name;
  String description;
  int countdown;
  String videoUrl;

  Instruction(
      {this.id, this.name, this.description, this.countdown, this.videoUrl});

  factory Instruction.fromJson(Map<String, dynamic> json) =>
      _$InstructionFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionToJson(this);
}

@JsonSerializable()
class Routine {
  int id;
  String title;
  String source;
  List<Instruction> instructions;

  Routine({this.id, this.title, this.source, this.instructions});

  factory Routine.fromJson(Map<String, dynamic> json) =>
      _$RoutineFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineToJson(this);
}

@JsonSerializable()
class RoutineList {
  List<Routine> routines;

  RoutineList({this.routines});

  factory RoutineList.fromJson(List<dynamic> json) {
    return RoutineList(
        routines: json
            .map((e) => Routine.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
