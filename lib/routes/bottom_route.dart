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

  bool isPlayerVisible = false;

  /// This is true when PlayButton is visible and is false when PauseButton is visible
  bool canPlay = false;

  String get playerTitle {
    if (routine?.title == null) return '';

    return '${routine.title}'
        "${selectedInstruction?.name != null ? ": ${selectedInstruction?.name}" : ""}";
  }

  @override
  void initState() {
    super.initState();

    CastManager.instance.castConnectionState
        .addListener(_onCastConnectionStateChanged);
    CastManager.instance.castPlayerState.addListener(_onCastPlayerStateChanged);
    CastManager.instance.routine.addListener(_onRoutineChanged);
    CastManager.instance.lastSelectedInstruction
        .addListener(this._onInstructionChanged);
  }

  Widget _getPlayer() {
    if (!isPlayerVisible) return Container();

    return PlayerWidget(
      title: playerTitle,
      playPauseState:
          canPlay ? PlayPauseStateValue.Play : PlayPauseStateValue.Pause,
    );
  }

  void _onCastConnectionStateChanged() {
    bool isPlayerVisible = false;
    bool canPlay = false;

    switch (CastManager.instance.castConnectionState.value) {
      case CastConnectionState.CONNECTED:
        isPlayerVisible = true;
        canPlay = true;
        break;
      case CastConnectionState.NOT_CONNECTED:
        isPlayerVisible = false;
        canPlay = true;
        break;
    }

    setState(() {
      this.isPlayerVisible = isPlayerVisible;
      this.canPlay = canPlay;
    });
  }

  void _onCastPlayerStateChanged() {
    bool canPlay = false;

    switch (CastManager.instance.castPlayerState.value) {
      case CastPlayerState.LOADED:
      case CastPlayerState.STOPPED:
      case CastPlayerState.PAUSED:
        canPlay = true;
        break;

      case CastPlayerState.PLAYING:
        canPlay = false;
        break;

      case CastPlayerState.UNLOADED:
        // pass
        break;
    }

    setState(() {
      this.canPlay = canPlay;
    });
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
        child: _getPlayer(),
      ),
    );
  }
}
