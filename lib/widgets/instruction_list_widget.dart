import 'package:cast_your_instructions_flutter/models/routine.dart';
import 'package:flutter/material.dart';

class InstructionListWidget extends StatelessWidget {
  InstructionListWidget({this.instructions});

  final List<Instruction> instructions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: instructions?.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              child: Text(index.toString()),
            ),
            title: Text(instructions[index].name),
          );
        });
  }
}
