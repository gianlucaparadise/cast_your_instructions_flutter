import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:provider/provider.dart';

import '../models/routine.dart';
import 'package:flutter/material.dart';

class RoutineListWidget extends StatelessWidget {
  RoutineListWidget({this.routineList, this.onTap});

  final RoutineList routineList;
  final Function(Routine) onTap;

  Widget _getListTileForCastManager(CastManager castManager, Routine routine) {
    bool isSelected = castManager.routine?.id == routine.id;

    Widget textTitle;
    if (isSelected) {
      textTitle = Text(
        "${routine.title}",
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      textTitle = Text("${routine.title}");
    }

    return ListTile(
      title: textTitle,
      onTap: () => onTap?.call(routine),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: routineList.routines.length,
        itemBuilder: (context, index) {
          Routine routine = routineList.routines[index];
          return Consumer<CastManager>(
            builder: (context, castManager, child) =>
                _getListTileForCastManager(castManager, routine),
          );
        });
  }
}
