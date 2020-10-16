import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart'; 
import 'package:letstogether/core/model/entity/attendees.dart'; 
import 'package:letstogether/core/services/attendees_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_cards.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/drawer_page.dart';

import 'package:http/http.dart' as http;

class MemberProfileAttendedActivities extends StatefulWidget {

  MemberProfileAttendedActivities({this.memberKey});

  final String memberKey;

  @override
  _MemberProfileAttendedActivitiesState createState() => _MemberProfileAttendedActivitiesState();
}

class _MemberProfileAttendedActivitiesState extends State<MemberProfileAttendedActivities> {
  List<Attendees> attendeesList; 
  AttendeesService service;

  String _memberKey ="";
 

   @override
  void initState() {
    super.initState();
    service = AttendeesService();
    _memberKey =
        SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title:
                AppLocalizations.of(context).translate('memberAttendedActivityTitle')),
      drawer: DrawerPage(   ),
        // body: Center(child: SwipeList()));
        //body: _listAttendees(),
        body : attendedActivityBuilder, );
  }
 
 Widget get attendedActivityBuilder => FutureBuilder( 
    future: service.getActivityListByJoinedMemberId(_memberKey,false,true),
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
    attendeesList = list;
    attendeesList.sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
        itemCount: attendeesList.length,
        itemBuilder: (context, index) =>
           CommonCards.instance.activityCard(attendeesList[index].activity, context, false));
  }
  
}