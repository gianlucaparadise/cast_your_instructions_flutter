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
            home: RoutineListRoute(title: 'Cast your Instructions'),
          ),
        ),
        BottomRoute(),
      ],
    );
  }
}
