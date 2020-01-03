import 'package:flutter/foundation.dart';

import '../models/routine.dart';
import 'package:flutter_cast_framework/cast.dart';

import 'models/cast_message.dart';
import 'models/cast_message_response.dart';

class CastManager {
  final _namespace = 'urn:x-cast:cast-your-instructions';

  final routine = ValueNotifier<Routine>(null);
  final lastSelectedInstruction = ValueNotifier<Instruction>(null);
  final castConnectionState = ValueNotifier(CastConnectionState.NOT_CONNECTED);
  final castPlayerState = ValueNotifier(CastPlayerState.UNLOADED);

  static CastManager _instance;

  static CastManager get instance {
    if (_instance == null) {
      _instance = CastManager._internal();
    }

    return _instance;
  }

  CastManager._internal() {
    FlutterCastFramework.namespaces = [_namespace];
    FlutterCastFramework.castContext.sessionManager.onMessageReceived =
        _onMessageReceived;
    FlutterCastFramework.castContext.sessionManager.state
        .addListener(_onSessionStateChanged);
  }

  void load(Routine routine) {
    var message = new CastMessage(MessageType.LOAD, routine);
    _sendMessage(message);
  }

  void play() {
    var message = CastMessage(MessageType.PLAY);
    _sendMessage(message);
  }

  void pause() {
    var message = CastMessage(MessageType.PAUSE);
    _sendMessage(message);
  }

  void stop() {
    var message = CastMessage(MessageType.STOP);
    _sendMessage(message);
  }

  void _sendMessage(CastMessage message) {
    try {
      var sessionManager = FlutterCastFramework.castContext.sessionManager;
      if (sessionManager == null) {
        debugPrint("CastManager: No session");
        return;
      }

      var messageString = message.toJsonString();
      sessionManager.sendMessage(_namespace, messageString);
    } on Exception catch (ex) {
      debugPrint("CastManager: Error while sending ${message.type}:");
      debugPrint(ex.toString());
    }
  }

  void _onMessageReceived(String namespace, String message) {
    if (message == null) return;

    debugPrint("CastManager: onMessageReceived: $message");

    CastMessageResponse responseMessage =
        CastMessageResponse.fromJsonString(message);

    debugPrint("CastManager: onMessageReceived parse: ${responseMessage.routine?.title}");

    var routine = responseMessage.routine;
    this.routine.value = responseMessage.routine;

    switch (responseMessage.type) {
      case ResponseMessageType.LOADED:
        castPlayerState.value = CastPlayerState.LOADED;
        lastSelectedInstruction.value = null;
        break;

      case ResponseMessageType.PLAYED:
        castPlayerState.value = CastPlayerState.PLAYING;
        break;

      case ResponseMessageType.PAUSED:
        castPlayerState.value = CastPlayerState.PAUSED;
        break;

      case ResponseMessageType.STOPPED:
        castPlayerState.value = CastPlayerState.STOPPED;
        lastSelectedInstruction.value = null;
        break;

      case ResponseMessageType.SELECTED_INSTRUCTION:
        var selectedInstructionIndex = responseMessage.selectedInstructionIndex;

        if (selectedInstructionIndex < routine?.instructions?.length) {
          lastSelectedInstruction.value =
              routine.instructions[selectedInstructionIndex];
        }
        break;
    }
  }

  void _onSessionStateChanged() {
    switch (FlutterCastFramework.castContext.sessionManager.state.value) {
      case SessionState.session_start_failed:
      case SessionState.session_resume_failed:
      case SessionState.session_ended:
        castConnectionState.value = CastConnectionState.NOT_CONNECTED;
        routine.value = null;
        lastSelectedInstruction.value = null;
        break;

      case SessionState.session_started:
      case SessionState.session_resumed:
        castConnectionState.value = CastConnectionState.CONNECTED;
        break;

      case SessionState.idle:
      case SessionState.session_starting:
      case SessionState.session_ending:
      case SessionState.session_resuming:
      case SessionState.session_suspended:
        // pass
        break;
    }
  }
}

enum CastConnectionState {
  NOT_CONNECTED,
  CONNECTED,
}

enum CastPlayerState {
  UNLOADED,
  LOADED,
  STOPPED,
  PLAYING,
  PAUSED,
}
