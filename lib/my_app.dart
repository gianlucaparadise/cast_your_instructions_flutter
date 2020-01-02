import 'package:cast_your_instructions_flutter/notification/cast_notification_handler.dart';
import 'package:flutter/material.dart';

import 'routes/routine_list_route.dart';
import './routes/bottom_route.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MaterialApp(
            title: 'Cast your Instructions',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: FutureBuilder(
              future: _initApp(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return RoutineListRoute(title: 'Cast your Instructions');
              },
            ),
          ),
        ),
        BottomRoute(),
      ],
    );
  }

  Future<void> _initApp() async {
    await CastNotificationHandler.instance.init();
  }
}
