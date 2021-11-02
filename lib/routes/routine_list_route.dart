import 'dart:convert' show json;

import 'package:cast_your_instructions_flutter/cast/cast_manager.dart';
import 'package:provider/provider.dart';

import '../models/routine.dart';
import 'routine_detail_route.dart';
import '../widgets/routine_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_cast_framework/widgets.dart';

class RoutineListRoute extends StatefulWidget {
  RoutineListRoute({Key? key, required this.title}) : super(key: key);

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
    CastManager castManager = Provider.of<CastManager>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: CastIcon(
              castFramework: castManager.castFramework,
            ),
            onPressed: () =>
                castManager.castFramework.castContext.showCastChooserDialog(),
          ),
        ],
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

            var routineList = snapshot.data?.routines;
            if (routineList == null) {
              return SizedBox.shrink(); // Empty view
            }

            return RoutineListWidget(
              routineList: routineList,
              onTap: (routine) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            RoutineDetailRoute(routine: routine)));
              },
            );
          }),
    );
  }
}
