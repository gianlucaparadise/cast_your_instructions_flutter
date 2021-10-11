import '../cast/cast_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerWidget extends StatelessWidget {
  PlayerWidget({
    this.playPauseState = PlayPauseStateValue.Play,
    this.title = '',
  });

  final PlayPauseStateValue playPauseState;
  final String title;

  void _onPlayPressed(BuildContext context) {
    var castState = Provider.of<CastManager>(context, listen: false);
    castState.play();
  }

  void _onPausePressed(BuildContext context) {
    var castState = Provider.of<CastManager>(context, listen: false);
    castState.pause();
  }

  void _onStopPressed(BuildContext context) {
    var castState = Provider.of<CastManager>(context, listen: false);
    castState.stop();
  }

  Widget _getPlayPauseButton(BuildContext context) {
    if (playPauseState == PlayPauseStateValue.Play) {
      return IconButton(
        icon: Icon(Icons.play_arrow),
        onPressed: () => _onPlayPressed(context),
      );
    }

    if (playPauseState == PlayPauseStateValue.Pause) {
      return IconButton(
        icon: Icon(Icons.pause),
        onPressed: () => _onPausePressed(context),
      );
    }

    debugPrint('playPauseState not handled: $playPauseState');

    return SizedBox.shrink(); // Empty view
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getPlayPauseButton(context),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () => _onStopPressed(context),
            ),
          ],
        ),
      ],
    );
  }
}

enum PlayPauseStateValue {
  Play,
  Pause,
}
