import 'models/cast_message.dart';
import 'models/cast_message_response.dart';
import '../models/routine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cast_framework/cast.dart';

class CastManager extends ChangeNotifier {
  final _namespace = 'urn:x-cast:cast-your-instructions';

  Routine? _routine;
  Routine? get routine => _routine;

  Instruction? _lastSelectedInstruction;
  Instruction? get lastSelectedInstruction => _lastSelectedInstruction;

  CastConnectionState _castConnectionState = CastConnectionState.NOT_CONNECTED;
  CastConnectionState get castConnectionState => _castConnectionState;

  CastPlayerState _castPlayerState = CastPlayerState.UNLOADED;
  CastPlayerState get castPlayerState => _castPlayerState;

  CastManager() {
    debugPrint("CastState: constructed");
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
      var messageString = message.toJsonString();
      sessionManager.sendMessage(_namespace, messageString);
    } on Exception catch (ex) {
      debugPrint("CastState: Error while sending ${message.type}:");
      debugPrint(ex.toString());
    }
  }

  void _onMessageReceived(String namespace, String message) {
    debugPrint("CastState: onMessageReceived: $message");

    CastMessageResponse responseMessage =
        CastMessageResponse.fromJsonString(message);

    debugPrint(
        "CastState: onMessageReceived parse: ${responseMessage.routine?.title}");

    var routine = responseMessage.routine;
    _routine = responseMessage.routine;

    switch (responseMessage.type) {
      case ResponseMessageType.LOADED:
        _castPlayerState = CastPlayerState.LOADED;
        _lastSelectedInstruction = null;
        break;

      case ResponseMessageType.PLAYED:
        _castPlayerState = CastPlayerState.PLAYING;
        break;

      case ResponseMessageType.PAUSED:
        _castPlayerState = CastPlayerState.PAUSED;
        break;

      case ResponseMessageType.STOPPED:
        _castPlayerState = CastPlayerState.STOPPED;
        _lastSelectedInstruction = null;
        break;

      case ResponseMessageType.SELECTED_INSTRUCTION:
        var lastSelectedInstruction =
            _getLastSelectedInstruction(responseMessage, routine);
        if (lastSelectedInstruction != null) {
          _lastSelectedInstruction = lastSelectedInstruction;
        }
        break;

      case null:
        debugPrint("CastState: onMessageReceived type null");
    }

    notifyListeners();
  }

  Instruction? _getLastSelectedInstruction(
      CastMessageResponse responseMessage, Routine? routine) {
    var selectedInstructionIndex = responseMessage.selectedInstructionIndex;
    if (selectedInstructionIndex == null) return null;

    var instructions = routine?.instructions;
    if (instructions == null) return null;

    if (selectedInstructionIndex < instructions.length) {
      return instructions[selectedInstructionIndex];
    }

    return null;
  }

  void _onSessionStateChanged() {
    switch (FlutterCastFramework.castContext.sessionManager.state.value) {
      case SessionState.session_start_failed:
      case SessionState.session_resume_failed:
      case SessionState.session_ended:
        _castConnectionState = CastConnectionState.NOT_CONNECTED;
        _routine = null;
        _lastSelectedInstruction = null;
        break;

      case SessionState.session_started:
      case SessionState.session_resumed:
        _castConnectionState = CastConnectionState.CONNECTED;
        break;

      case SessionState.idle:
      case SessionState.session_starting:
      case SessionState.session_ending:
      case SessionState.session_resuming:
      case SessionState.session_suspended:
        return;
    }

    notifyListeners();
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
