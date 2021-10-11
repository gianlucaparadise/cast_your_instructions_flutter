import 'package:cast_your_instructions_flutter/notification/cast_notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cast/cast_manager.dart';
import 'routes/routine_list_route.dart';
import './routes/bottom_route.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CastManager(),
        ),
        ProxyProvider<CastManager, CastNotificationHandler?>(
          create: (context) => CastNotificationHandler(),
          update: (context, castState, castNotificationHandler) {
            castNotificationHandler?.onCastStateUpdated(castState);
            return castNotificationHandler;
          },
          lazy: false, // This needs to be created on app start
        )
      ],
      child: Column(
        children: [
          Expanded(
            child: MaterialApp(
              title: 'Cast your Instructions',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: RoutineListRoute(title: 'Cast your Instructions'),
            ),
          ),
          BottomRoute(),
        ],
      ),
    );
  }
}
