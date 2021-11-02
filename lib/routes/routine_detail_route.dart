import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:flutter_cast_framework/widgets.dart';
import 'package:provider/provider.dart';

import '../models/routine.dart';
import '../widgets/instruction_list_widget.dart';
import 'package:flutter/material.dart';

class RoutineDetailRoute extends StatefulWidget {
  RoutineDetailRoute({required this.routine});

  final Routine routine;

  @override
  State<StatefulWidget> createState() => _RoutineDetailRouteState();
}

class _RoutineDetailRouteState extends State<RoutineDetailRoute> {
  void _onCastPressed() {
    CastManager castState = Provider.of<CastManager>(context, listen: false);
    castState.load(widget.routine);
  }

  Widget _getCastButtonForCastManager(CastManager castManager) {
    // When connected I return an enabled button
    // When disconnected I return a disabled button

    if (castManager.castConnectionState == CastConnectionState.CONNECTED) {
      return ElevatedButton(
        child: Text('Cast'),
        onPressed: _onCastPressed,
      );
    }

    return ElevatedButton(
      child: Text('Cast'),
      onPressed: null, // when click is null, button is disabled
    );
  }

  Widget _getInstructionList() {
    var instructions = widget.routine.instructions;

    if (instructions == null) return SizedBox.shrink(); // Empty view

    return Expanded(
      child: InstructionListWidget(
        routine: widget.routine,
        instructions: instructions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CastManager castManager = Provider.of<CastManager>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        actions: [
          IconButton(
            icon: CastIcon(
              castFramework: castManager.castFramework,
            ),
            onPressed: () =>
                castManager.castFramework.castContext.showCastChooserDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 16, left: 16, top: 16, right: 8),
                  child: Text(
                    "${widget.routine.title}",
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 16, left: 8, top: 16, right: 16),
                child: Consumer<CastManager>(
                  builder: (context, castManager, child) =>
                      _getCastButtonForCastManager(castManager),
                ),
              ),
            ],
          ),
          _getInstructionList()
        ],
      ),
    );
  }
}
