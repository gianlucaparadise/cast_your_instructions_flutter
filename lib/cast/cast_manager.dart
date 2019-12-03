import 'package:flutter/foundation.dart';

import '../models/routine.dart';
import 'package:flutter_cast_framework/cast.dart';

import 'models/cast_message.dart';
import 'models/cast_message_response.dart';

class CastManager {

  final _namespace = 'urn:x-cast:cast-your-instructions';

  final routine = ValueNotifier<Routine>(null);
  final lastSelectedInstruction = ValueNotifier<Instruction>(null);

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
        debugPrint("No session");
        return;
      }

      var messageString = message.toJsonString();
      sessionManager.sendMessage(_namespace, messageString);
    } on Exception catch (ex) {
      debugPrint("Error while sending ${message.type}:");
      debugPrint(ex.toString());
    }
  }

  void _onMessageReceived(String namespace, String message) {
    if (message == null) return;

    debugPrint("onMessageReceived: $message");

    CastMessageResponse responseMessage = CastMessageResponse.fromJsonString(message);

    debugPrint("onMessageReceived parse: ${responseMessage.routine?.title}");

    var routine = responseMessage.routine;
    this.routine.value = responseMessage.routine;

    switch (responseMessage.type) {
      case ResponseMessageType.LOADED:
      // TODO: Handle this case.
        break;
      case ResponseMessageType.PLAYED:
      // TODO: Handle this case.
        break;
      case ResponseMessageType.PAUSED:
      // TODO: Handle this case.
        break;
      case ResponseMessageType.STOPPED:
      // TODO: Handle this case.
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
}