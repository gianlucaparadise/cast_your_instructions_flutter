import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CastNotificationHandler with WidgetsBindingObserver {
  static CastNotificationHandler _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String channelName = "Cast your Instruction Player";
  final String channelDescription =
      "Player to control the casted instruction on the TV";
  final String channelId = "cast:instruction:player:channel";
  final int notificationId = 7;

  bool _isInitialized = false;
  bool isAppInBackground = false;

  static CastNotificationHandler get instance {
    if (_instance == null) {
      _instance = CastNotificationHandler._internal();
    }

    return _instance;
  }

  CastNotificationHandler._internal() {
    debugPrint("CastNotificationHandler constructed");
  }

  Future<void> init() async {
    if (this._isInitialized) return;
    debugPrint("CastNotificationHandler init");
    this._isInitialized = true;

    try {
      //region FlutterLocalNotification plugin init
      var initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      var initializationSettingsIOS = IOSInitializationSettings(
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: _onSelectNotification,
        onNotificationActionTapped: _onNotificationActionTapped,
      );
      //endregion

      // this is to listen to background/foreground
      WidgetsBinding.instance.addObserver(this);

      CastManager.instance.castPlayerState
          .addListener(_onCastPlayerStateChanged);
      CastManager.instance.castConnectionState
          .addListener(_onCastConnectionStateChanged);
      CastManager.instance.lastSelectedInstruction
          .addListener(_onLastSelectedInstructionChanged);
    } catch (exception) {
      debugPrint(
          "CastNotificationHandler: Error while initialization:\n${exception.toString()}");
      this._isInitialized = false;
    }
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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("CastNotificationHandler didChangeAppLifecycleState $state");
    if (state == AppLifecycleState.paused) {
      isAppInBackground = true;
      _showNotification();
    } else if (state == AppLifecycleState.resumed) {
      isAppInBackground = false;
      _cancelNotification();
    }
  }

  Future<void> _showNotification() async {
    // I can show the notification only when app is in background
    if (!isAppInBackground) return;

    // I can show the notification only when a routine has been loaded
    if (CastManager.instance.castPlayerState.value == CastPlayerState.UNLOADED) return;

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
    if (CastManager.instance.castPlayerState.value == CastPlayerState.PLAYING) {
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

    var title = CastManager.instance.routine?.value?.title;
    var instructionName = CastManager
        .instance.lastSelectedInstruction?.value?.name; // FIXME: this is empty

    debugPrint("InstructionsName: $instructionName");
    debugPrint(
        "LastSelectedInstruction: ${CastManager.instance.lastSelectedInstruction}");

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

  //region CastManager lifecycle listeners
  void _onCastPlayerStateChanged() {
    CastPlayerState state = CastManager.instance.castPlayerState.value;

    switch (state) {
      case CastPlayerState.LOADED:
      case CastPlayerState.PLAYING:
      case CastPlayerState.PAUSED:
        _showNotification();
        break;
      case CastPlayerState.STOPPED:
      case CastPlayerState.UNLOADED:
        _cancelNotification();
        break;
    }
  }

  void _onCastConnectionStateChanged() {
    CastConnectionState state = CastManager.instance.castConnectionState.value;

    switch (state) {
      case CastConnectionState.NOT_CONNECTED:
        _cancelNotification();
        break;
      case CastConnectionState.CONNECTED:
        // pass
        break;
    }
  }

  void _onLastSelectedInstructionChanged() {
    debugPrint("CastNotificationHandler _onLastSelectedInstructionChanged");
    _showNotification();
  }
  //endregion
}
