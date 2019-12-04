import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  PlayerWidget({
    this.playPauseState = PlayPauseStateValue.Play,
    this.title = '',
  });

  final PlayPauseStateValue playPauseState;
  final String title;

  void _onPlayPressed() {
    CastManager.instance.play();
  }

  void _onPausePressed() {
    CastManager.instance.pause();
  }

  void _onStopPressed() {
    CastManager.instance.stop();
  }

  IconButton _getPlayPauseButton() {
    if (playPauseState == PlayPauseStateValue.Play) {
      return IconButton(
        icon: Icon(Icons.play_arrow),
        onPressed: _onPlayPressed,
      );
    }

    if (playPauseState == PlayPauseStateValue.Pause) {
      return IconButton(
        icon: Icon(Icons.pause),
        onPressed: _onPausePressed,
      );
    }

    debugPrint('playPauseState not handled: $playPauseState');

    return null;
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
            _getPlayPauseButton(),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: _onStopPressed,
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
