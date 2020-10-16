import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/attendees.dart';
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';
import 'package:letstogether/core/services/attendees_service.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/view/home/activity_attendees_approved.dart';
import 'package:letstogether/ui/view/home/activity_attendees_waiting.dart';
import 'package:letstogether/ui/view/home/activity_attendees_rejected.dart';
import 'package:http/http.dart' as http;

class ActivityAttendeesTabbar extends StatefulWidget {
  @override
  _ActivityAttendeesTabbarState createState() =>
      _ActivityAttendeesTabbarState();

  ActivityAttendeesTabbar({this.activity});

  final Activity activity;
}

class _ActivityAttendeesTabbarState extends State<ActivityAttendeesTabbar> {
  AttendeesService service;

  @override
  void initState() {
    super.initState();
    service = AttendeesService();
  }

  Widget get activityAttendessBuilder => FutureBuilder(
        future: service.getAttendeesByActivityId(widget.activity.key),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data is List) {
                  List<Attendees> attendeesList = snapshot.data;
                  List<Attendees> waitingList = new List();
                  List<Attendees> approvedList = new List();
                  List<Attendees> rejectedList = new List();

                  for (Attendees attendee in attendeesList) {
                    if (attendee.statusEnum == ActivityAttendStatusEnum.WAITING)
                      waitingList.add(attendee);
                    else if (attendee.statusEnum ==
                        ActivityAttendStatusEnum.APPROVED)
                      approvedList.add(attendee);
                    else if (attendee.statusEnum ==
                        ActivityAttendStatusEnum.REJECTED)
                      rejectedList.add(attendee);
                  }
                  return TabBarView(children: <Widget>[
                    ActivityAttendeesWaiting(attendeesList: waitingList),
                    ActivityAttendeesApproved(attendeesList: approvedList),
                    ActivityAttendeesRejected(attendeesList: rejectedList),
                  ]);
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: SafeArea(
            child: TabBar(
                unselectedLabelColor: Theme.of(context).primaryColorLight,
                labelColor: Theme.of(context).primaryColorDark,
                tabs: <Widget>[
                  Tab(
                    child: Icon(Icons.schedule),
                  ),
                  Tab(
                    child: Icon(Icons.done),
                  ),
                  Tab(
                    child: Icon(Icons.clear),
                  ),
                ]),
          ),
          body: activityAttendessBuilder,
        ));
  }
}
