import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart';   
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_cards.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/drawer_page.dart';  
import 'package:http/http.dart' as http; 
import 'package:letstogether/core/services/activity/activity_service_creator.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';

class MyCreatedActivities extends StatefulWidget {
  
  MyCreatedActivities({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);


  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
 
  @override
  _MyCreatedActivitiesState createState() => _MyCreatedActivitiesState();
}

class _MyCreatedActivitiesState extends State<MyCreatedActivities> {
  List<Activity> activityList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ActivityService service;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";
  String _memberKey ="";
 
 
  @override
  void initState() {
    super.initState();
    service = ActivityServiceCreator.instance;
    _memberKey =
        SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title:
                AppLocalizations.of(context).translate('myCreatedActivities')),
      drawer: DrawerPage(   ),
        // body: Center(child: SwipeList()));
        //body: _listAttendees(),
        body : createdActivityBuilder,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _fabButton);
  }
  
  Widget get createdActivityBuilder => FutureBuilder( 
    future: service.getActivityListByMemberId(_memberKey,true),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.done:
          if (snapshot.hasData) {
            if (snapshot.data is List) {
              return _listAttendees(snapshot.data);
            } else if (snapshot.data is http.Response) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await SharedManager.instance
                    .saveString(SharedKeys.TOKEN, "");
                Navigator.of(context).pop();
              });
            }
          }
          return CommonWidgets.instance.notFoundWidget;

        default:
          return CommonWidgets.instance.waitingWidget;
      }
    },
  );


  Widget get _fabButton => FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/activityCreate");
        },
        child: Icon(Icons.add),
      );
 
  Widget _listAttendees(List<dynamic> list) {
    activityList = list;
    activityList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return ListView.builder(
        itemCount: activityList.length,
        itemBuilder: (context, index) =>
           CommonCards.instance.activityCard(activityList[index], context,true));
  }
 
}