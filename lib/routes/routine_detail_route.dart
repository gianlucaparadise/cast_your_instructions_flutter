import 'package:cast_your_instructions_flutter/models/routine.dart';
import 'package:cast_your_instructions_flutter/widgets/instruction_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutineDetailRoute extends StatefulWidget {
  RoutineDetailRoute({this.routine});

  final Routine routine;

  @override
  State<StatefulWidget> createState() => _RoutineDetailRouteState();
}

class _RoutineDetailRouteState extends State<RoutineDetailRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.routine.title,
                style: Theme.of(context).textTheme.headline,
              )),
          Expanded(
              child: InstructionListWidget(
            instructions: widget.routine.instructions,
          ))
        ],
      ),
    );
  }
}
