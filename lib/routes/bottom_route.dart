import 'package:provider/provider.dart';
import '../cast/cast_state.dart';
import '../widgets/player_widget.dart';
import 'package:flutter/material.dart';

/// I know currently this is not a route, but this can become it
class BottomRoute extends StatelessWidget {
  bool isPlayerVisibleForState(CastState castState) {
    switch (castState.castConnectionState) {
      case CastConnectionState.CONNECTED:
        return true;
      case CastConnectionState.NOT_CONNECTED:
        return false;
    }

    return false;
  }

  bool canPlayForState(CastState castState) {
    switch (castState.castPlayerState) {
      case CastPlayerState.LOADED:
      case CastPlayerState.STOPPED:
      case CastPlayerState.PAUSED:
        return true;

      case CastPlayerState.PLAYING:
        return false;

      case CastPlayerState.UNLOADED:
        // pass
        break;
    }

    return true; // When in doubt, I want the play button
  }

  String getPlayerTitleForState(CastState castState) {
    var routine = castState.routine;
    if (routine?.title == null) return '';

    var selectedInstruction = castState.lastSelectedInstruction;

    return '${routine.title}'
        "${selectedInstruction?.name != null ? ": ${selectedInstruction?.name}" : ""}";
  }

  Widget _getPlayer(CastState castState) {
    bool isPlayerVisible = isPlayerVisibleForState(castState);
    if (!isPlayerVisible) return Container();

    bool canPlay = canPlayForState(castState);
    String playerTitle = getPlayerTitleForState(castState);

    return PlayerWidget(
      title: playerTitle,
      playPauseState:
          canPlay ? PlayPauseStateValue.Play : PlayPauseStateValue.Pause,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Consumer<CastState>(
            builder: (context, castState, child) => _getPlayer(castState)),
      ),
    );
  }
}
