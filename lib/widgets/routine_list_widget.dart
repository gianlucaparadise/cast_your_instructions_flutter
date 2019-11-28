import 'package:cast_your_instructions_flutter/models/routine.dart';
import 'package:flutter/material.dart';

class RoutineListWidget extends StatelessWidget {
  RoutineListWidget({this.routineList, this.onTap});

  final RoutineList routineList;
  final Function(Routine) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: routineList.routines.length,
        itemBuilder: (context, index) {
          Routine routine = routineList.routines[index];
          return ListTile(
            title: Text("${routine.title}"),
            onTap: () => onTap?.call(routine),
          );
        });
  }
}
