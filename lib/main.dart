import 'package:flutter/material.dart';
import 'package:letstogether/core/model/authentication/auth.dart';
import 'package:letstogether/ui/authentication/root_page.dart';
import 'package:letstogether/ui/base/auth_user.dart';
import 'package:letstogether/ui/base/custom_theme_data.dart';
import 'package:letstogether/ui/other/tabbar_view.dart';
import 'package:letstogether/ui/view/home/activity_create_view.dart';
import 'package:letstogether/ui/view/home/activity_detail.dart';
import 'package:letstogether/ui/view/home/configuration_page_view.dart';
import 'package:letstogether/ui/view/base/main_member.dart';
import 'package:letstogether/ui/view/home/member_profile_main.dart';
import 'package:letstogether/ui/view/home/activity_list_view.dart';
import 'package:letstogether/ui/view/home/member_profile_edit.dart';
import 'package:provider/provider.dart';
import 'core/helper/shared_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedManager.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(builder: (context) => CustomThemeDataModal()),
      ChangeNotifierProvider(builder: (context) => AuthUser()),
      ChangeNotifierProvider(builder: (context) => MainMemberDataModal()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: TabbarView(),
      title: "MterialApp",
      theme: Provider.of<CustomThemeDataModal>(context).getThemeData,
      /*
      initialRoute: "ActivityListView",
      routes: {
         "/": (context) => LoginView(),
        "/activityList" : (context) => ActivityListView(),
        "/activityCreate" : (context) => new MyHomePage(title: 'Flutter Form Demo'),
        "/activityDetail" : (context) => new ActivityDetail(),
        "/main" : (context) => TabbarView(),

      },
      */
      debugShowCheckedModeBanner: false,
      //theme: new ThemeData(
      //  primarySwatch: Colors.blue,
      //),
      routes: {
        "/": (context) => new RootPage(auth: new Auth()),
        "/activityList": (context) => ActivityListView(),
        "/activityCreate": (context) => ActivityCreate(),
        "/activityDetail": (context) => new ActivityDetail(),
        "/myProfile": (context) => new MemberProfile(),
        "/editProfile": (context) => new MemberProfileEdit(),
        "/configurationPage": (context) => new ConfigurationPage(),
        "/main": (context) => TabbarView(),
      },
      /*
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Form Demo'),
*/
    );
  }
}
