import 'package:provider/provider.dart';
import '../cast/cast_manager.dart';
import '../widgets/player_widget.dart';
import 'package:flutter/material.dart';

/// I know currently this is not a route, but this can become it
class BottomRoute extends StatelessWidget {
  bool isPlayerVisibleForState(CastManager castState) {
    switch (castState.castConnectionState) {
      case CastConnectionState.CONNECTED:
        return true;
      case CastConnectionState.NOT_CONNECTED:
        return false;
    }

    return false;
  }

  bool canPlayForState(CastManager castState) {
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

  String getPlayerTitleForState(CastManager castState) {
    var routine = castState.routine;
    if (routine?.title == null) return '';

    var selectedInstruction = castState.lastSelectedInstruction;

    return '${routine.title}'
        "${selectedInstruction?.name != null ? ": ${selectedInstruction?.name}" : ""}";
  }

  Widget _getPlayer(CastManager castState) {
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
        child: Consumer<CastManager>(
            builder: (context, castState, child) => _getPlayer(castState)),
      ),
    );
  }
}
