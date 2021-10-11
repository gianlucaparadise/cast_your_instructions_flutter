import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:provider/provider.dart';

import '../models/routine.dart';
import 'package:flutter/material.dart';

class InstructionListWidget extends StatelessWidget {
  InstructionListWidget({required this.routine, required this.instructions});

  final Routine routine;
  final List<Instruction> instructions;

  Widget _getListTileForCastManager(
      CastManager castManager, int instructionIndex) {
    Instruction instruction = instructions[instructionIndex];

    bool isSameRoutine = castManager.routine?.id == routine.id;
    bool isSelected = isSameRoutine &&
        castManager.lastSelectedInstruction?.id == instruction.id;

    Widget textTitle;
    Widget textIndex;

    var instructionName = "${instruction.name}";

    if (isSelected) {
      textTitle = Text(
        instructionName,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
      textIndex = Text(
        instructionIndex.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      textTitle = Text(instructionName);
      textIndex = Text(instructionIndex.toString());
    }

    return ListTile(
      leading: Container(
        child: textIndex,
      ),
      title: textTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          return Consumer<CastManager>(
            builder: (context, castManager, child) =>
                _getListTileForCastManager(castManager, index),
          );
        });
  }
}
