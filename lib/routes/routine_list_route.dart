import 'dart:convert' show json;

import '../models/routine.dart';
import 'routine_detail_route.dart';
import '../widgets/routine_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class RoutineListRoute extends StatefulWidget {
  RoutineListRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoutineListRouteState createState() => _RoutineListRouteState();
}

class _RoutineListRouteState extends State<RoutineListRoute> {
  Future<RoutineList> loadStub() {
    return rootBundle.loadStructuredData<RoutineList>(
        'assets/stub/routines.json', (jsonStr) async {
      final secret = RoutineList.fromJson(json.decode(jsonStr));
      return secret;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<RoutineList>(
          future: loadStub(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("Error while loading routines"));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return RoutineListWidget(
              routineList: snapshot.data,
              onTap: (routine) {
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => RoutineDetailRoute(routine: routine)
                ));
              },
            );
          }),
    );
  }
}
