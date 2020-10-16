import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/activity.dart'; 
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_cards.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/drawer_page.dart';
import 'package:letstogether/core/services/activity/activity_service_creator.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';



import 'package:http/http.dart' as http;

class MemberProfileCreatedActivities extends StatefulWidget {

  MemberProfileCreatedActivities({this.memberKey});

  final String memberKey;

  @override
  _MemberProfileCreatedActivitiesState createState() => _MemberProfileCreatedActivitiesState();
}

class _MemberProfileCreatedActivitiesState extends State<MemberProfileCreatedActivities> {
  List<Activity> activityList;
  ActivityService service;

   @override
  void initState() {
    super.initState();
     service = ActivityServiceCreator.instance;  
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title:
                AppLocalizations.of(context).translate('memberCreatedActivityTitle')),
      drawer: DrawerPage(   ),
        // body: Center(child: SwipeList()));
        //body: _listAttendees(),
        body : createdActivityBuilder, );
  }

  Widget get createdActivityBuilder => FutureBuilder( 
    future: service.getActivityListByMemberId(widget.memberKey,false),
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


 
  Widget _listAttendees(List<dynamic> list) {
    activityList = list;
    activityList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return ListView.builder(
        itemCount: activityList.length,
        itemBuilder: (context, index) =>
           CommonCards.instance.activityCard(activityList[index], context, false));
  }
 
  
}