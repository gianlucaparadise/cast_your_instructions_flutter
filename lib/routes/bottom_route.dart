import '../cast/cast_manager.dart';
import '../models/routine.dart';
import '../widgets/player_widget.dart';
import 'package:flutter/material.dart';

/// I know currently this is not a route, but this can become it
class BottomRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomRouteState();
}

class _BottomRouteState extends State<BottomRoute> {
  Routine routine = CastManager.instance.routine.value;
  Instruction selectedInstruction =
      CastManager.instance.lastSelectedInstruction.value;

  String get playerTitle {
    return "${routine?.title}"
        "${selectedInstruction?.name != null ? ": " : ""}"
        "${selectedInstruction?.name}";
  }

  @override
  void initState() {
    super.initState();

    CastManager.instance.routine.addListener(this._onRoutineChanged);
    CastManager.instance.lastSelectedInstruction
        .addListener(this._onInstructionChanged);
  }

  void _onRoutineChanged() {
    setState(() {
      routine = CastManager.instance.routine.value;
    });
  }

  void _onInstructionChanged() {
    setState(() {
      selectedInstruction = CastManager.instance.lastSelectedInstruction.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PlayerWidget(
          title: playerTitle,
        ),
      ),
    );
  }
}
