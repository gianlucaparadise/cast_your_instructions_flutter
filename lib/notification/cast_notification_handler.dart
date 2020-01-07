import '../cast/cast_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CastNotificationHandler with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String channelName = "Cast your Instruction Player";
  final String channelDescription =
      "Player to control the casted instruction on the TV";
  final String channelId = "cast:instruction:player:channel";
  final int notificationId = 7;

  static const String actionPlayerPause = "PLAYER_PAUSE";
  static const String actionPlayerPlay = "PLAYER_PLAY";
  static const String actionPlayerStop = "PLAYER_STOP";

  bool isAppInBackground = false;

  CastState lastCastState;

  CastNotificationHandler() {
    debugPrint("CastNotificationHandler init");

    try {
      //region FlutterLocalNotification plugin init
      var initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      var initializationSettingsIOS = IOSInitializationSettings(
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);

      // FIXME: I should await the initialization, but it would make my code complex
      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: _onSelectNotification,
        onNotificationActionTapped: _onNotificationActionTapped,
      );
      //endregion

      // this is to listen to background/foreground
      WidgetsBinding.instance.addObserver(this);
    } catch (exception) {
      debugPrint(
          "CastNotificationHandler: Error while initialization:\n${exception.toString()}");
    }
  }

  void onCastStateUpdated(CastState castState) {
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

  Future<void> _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    debugPrint("CastNotificationHandler: onDidReceiveLocalNotification");
  }

  Future<void> _onSelectNotification(String payload) async {
    debugPrint("CastNotificationHandler: onSelectNotification");

    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future<void> _onNotificationActionTapped(
      String actionKey, Map<String, String> extras) async {
    debugPrint("CastNotificationHandler: onNotificationActionTapped");
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

  Future<void> _showNotification(CastState castState) async {
    // I can show the notification only when app is in background
    if (!isAppInBackground) return;

    // I can show the notification only when a routine has been loaded
    if (castState.castPlayerState == CastPlayerState.UNLOADED) return;

    var mediaStyleInformation = MediaStyleInformation(
      showActionsInCompactView: [0],
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.Low, // this is to avoid notification sound or vibration above Android 8.0
      priority: Priority.Low, // this is to avoid notification sound or vibration below Android 8.0
      ongoing: true,
      style: AndroidNotificationStyle.Media,
      styleInformation: mediaStyleInformation,
      visibility: NotificationVisibility.Public,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    List<NotificationAction> actions = [];
    if (castState.castPlayerState == CastPlayerState.PLAYING) {
      actions.add(NotificationAction(
        icon: 'baseline_pause_black_18dp',
        title: 'Pause',
        actionKey: 'PLAYER_PAUSE',
        // extras: {'extra2': 'pause_extra'},
      ));
    } else {
      actions.add(NotificationAction(
        icon: 'baseline_play_arrow_black_18dp',
        title: 'Play',
        actionKey: 'PLAYER_PLAY',
        // extras: {'extra1': 'play_extra'},
      ));
    }
    actions.add(NotificationAction(
      icon: 'baseline_stop_black_18dp',
      title: 'Stop',
      actionKey: 'PLAYER_STOP',
    ));

    var title = castState.routine?.title;
    var instructionName = castState.lastSelectedInstruction?.name; // FIXME: this is empty

    debugPrint("InstructionsName: $instructionName");
    debugPrint(
        "LastSelectedInstruction: ${castState.lastSelectedInstruction}");

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      instructionName,
      platformChannelSpecifics,
      actions: actions,
    );
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
