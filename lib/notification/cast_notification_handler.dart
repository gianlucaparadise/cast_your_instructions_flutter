import '../cast/cast_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class CastNotificationHandler with WidgetsBindingObserver {
  final String channelName = "Cast your Instruction Player";
  final String channelDescription =
      "Player to control the casted instruction on the TV";
  final String channelId = "cast:instruction:player:channel";
  final int notificationId = 7;

  static const String actionPlayerPause = "PLAYER_PAUSE";
  static const String actionPlayerPlay = "PLAYER_PLAY";
  static const String actionPlayerStop = "PLAYER_STOP";

  bool isAppInBackground = false;

  late CastManager lastCastState;

  CastNotificationHandler() {
    debugPrint("CastNotificationHandler init");

    try {
      //region AwesomeNotifications plugin init
      // FIXME: I should await the initialization, but it would make my code complex
      AwesomeNotifications().initialize(
        null, // Null to use default app icon
        [
          NotificationChannel(
            channelKey: channelId,
            channelName: channelName,
            channelDescription: channelDescription,
            // importance is to avoid notification sound or vibration above Android 8.0. When below 8.0, use priority prop
            importance: NotificationImportance.Low,
            playSound: false,
            enableVibration: false,
            // defaultPrivacy is to display the notification also on a locked screen
            defaultPrivacy: NotificationPrivacy.Public,
          ),
        ],
      ).then((value) {
        AwesomeNotifications().actionStream.listen(_onSelectNotification);
      });

      // this is to listen to background/foreground
      WidgetsFlutterBinding.ensureInitialized().addObserver(this);
    } catch (exception) {
      debugPrint(
          "CastNotificationHandler: Error while initialization:\n${exception.toString()}");
    }
  }

  void onCastStateUpdated(CastManager castState) {
    debugPrint("CastNotificationHandler: onCastStateUpdated");
    lastCastState = castState;

    CastConnectionState castConnectionState = castState.castConnectionState;

    switch (castConnectionState) {
      case CastConnectionState.NOT_CONNECTED:
        _cancelNotification();
        return;

      case CastConnectionState.CONNECTED:
        // pass: I will decide later what to do
        break;
    }

    CastPlayerState castPlayerState = castState.castPlayerState;

    switch (castPlayerState) {
      case CastPlayerState.LOADED:
      case CastPlayerState.PLAYING:
      case CastPlayerState.PAUSED:
        _showNotification(castState);
        break;
      case CastPlayerState.STOPPED:
      case CastPlayerState.UNLOADED:
        _cancelNotification();
        break;
    }
  }

  void _onCastUpdatedBackground() {
    debugPrint("CastNotificationHandler: _onCastUpdatedBackground");
    onCastStateUpdated(lastCastState);
  }

  void _onSelectNotification(ReceivedAction receivedNotification) {
    debugPrint("CastNotificationHandler: _onSelectNotification");

    var actionKey = receivedNotification.buttonKeyPressed;
    switch (actionKey) {
      case actionPlayerPause:
        lastCastState.pause();
        break;
      case actionPlayerPlay:
        lastCastState.play();
        break;
      case actionPlayerStop:
        lastCastState.stop();
        break;

      default:
        debugPrint("CastNotificationHandler: unhandled case $actionKey");
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("CastNotificationHandler didChangeAppLifecycleState $state");
    if (state == AppLifecycleState.paused) {
      isAppInBackground = true;

      // When in background, I don't get notified through the Provider anymore,
      // therefore I need to attach to listener
      // FIXME: I don't like very much this approach, but Provider helps me removing the singletons

      lastCastState.addListener(_onCastUpdatedBackground);
      _onCastUpdatedBackground();
    } else if (state == AppLifecycleState.resumed) {
      isAppInBackground = false;

      // Once in foreground, I get notified through the Provider,
      // therefore I can remove my listener

      lastCastState.removeListener(_onCastUpdatedBackground);
      _cancelNotification();
    }
  }

  Future<void> _showNotification(CastManager castState) async {
    // I can show the notification only when app is in background
    if (!isAppInBackground) return;

    var isNotificationAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    if (!isNotificationAllowed) {
      debugPrint("Can't display notifications - missing permissions");
      // TODO: Request permissions somewhere in the app
      return;
    }

    // I can show the notification only when a routine has been loaded
    if (castState.castPlayerState == CastPlayerState.UNLOADED) return;

    List<NotificationActionButton> actions = [];
    if (castState.castPlayerState == CastPlayerState.PLAYING) {
      actions.add(NotificationActionButton(
        icon: 'resource://drawable/baseline_pause_black_18dp',
        label: 'Pause',
        key: 'PLAYER_PAUSE',
        autoCancel: false,
        showInCompactView: true,
        buttonType: ActionButtonType.KeepOnTop,
      ));
    } else {
      actions.add(NotificationActionButton(
        icon: 'resource://drawable/baseline_play_arrow_black_18dp',
        label: 'Play',
        key: 'PLAYER_PLAY',
        autoCancel: false,
        showInCompactView: true,
        buttonType: ActionButtonType.KeepOnTop,
      ));
    }
    actions.add(NotificationActionButton(
      icon: 'resource://drawable/baseline_stop_black_18dp',
      label: 'Stop',
      key: 'PLAYER_STOP',
      autoCancel: false,
      showInCompactView: false,
      buttonType: ActionButtonType.KeepOnTop,
    ));

    var title = castState.routine?.title;
    var instructionName =
        castState.lastSelectedInstruction?.name; // FIXME: this is empty

    debugPrint("InstructionsName: $instructionName");
    debugPrint("LastSelectedInstruction: ${castState.lastSelectedInstruction}");

    await AwesomeNotifications().createNotification(
      actionButtons: actions,
      content: NotificationContent(
        id: notificationId,
        channelKey: channelId,
        title: title,
        body: instructionName,
        notificationLayout: NotificationLayout.MediaPlayer,
        autoCancel: false,
        showWhen: false,
        locked: true,
      ),
    );
  }

  Future<void> _cancelNotification() async {
    await AwesomeNotifications().cancel(notificationId);
  }
}
