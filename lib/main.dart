import 'package:flutter/material.dart';
import 'package:letstogether/ui/view/home/activity_create_view.dart';
import 'package:letstogether/ui/view/home/activity_list_view.dart';

import 'core/helper/shared_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       // home: TabbarView(),
       title: "MterialApp",
      initialRoute: "ActivityListView",
      routes: {
         "/": (context) => ActivityListView(),
        "/activityList" : (context) => ActivityListView(),
        "/activityCreate" : (context) => ActivityCreate(),
      },

    );
  }
}