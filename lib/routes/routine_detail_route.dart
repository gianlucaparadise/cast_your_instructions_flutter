import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:flutter_cast_framework/cast.dart';
import 'package:flutter_cast_framework/widgets.dart';

import '../models/routine.dart';
import '../widgets/instruction_list_widget.dart';
import 'package:flutter/material.dart';

class RoutineDetailRoute extends StatefulWidget {
  RoutineDetailRoute({this.routine});

  final Routine routine;

  @override
  State<StatefulWidget> createState() => _RoutineDetailRouteState();
}

class _RoutineDetailRouteState extends State<RoutineDetailRoute> {
  void _onCastPressed() {
    CastManager.instance.load(widget.routine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        actions: [
          IconButton(
            icon: CastIcon(),
            onPressed: () =>
                FlutterCastFramework.castContext.showCastChooserDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 16, top: 16, right: 8),
                  child: Text(
                    widget.routine.title,
                    style: Theme.of(context).textTheme.headline,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16, left: 8, top: 16, right: 16),
                child: RaisedButton(
                  child: Text('Cast'),
                  onPressed: _onCastPressed,
                ),
              ),
            ],
          ),
          Expanded(
              child: InstructionListWidget(
            instructions: widget.routine.instructions,
          ))
        ],
      ),
    );
  }
}
