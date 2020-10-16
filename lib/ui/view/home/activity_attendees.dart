import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart'; 
import 'package:letstogether/core/model/entity/attendees.dart'; 
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';
import 'package:letstogether/core/services/activity/activity_service_real.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/view/home/member_profile_tabbar.dart';

class ActivityAttendees extends StatefulWidget {
  ActivityAttendees({this.attendeesList});
 
  final List<Attendees> attendeesList;

  @override
  ActivityAttendeesState createState() => ActivityAttendeesState();
}

class ActivityAttendeesState extends State<ActivityAttendees> {
   final attendsReference =
      FirebaseDatabase.instance.reference().child('attends');

  static List<Attendees> newApprovedList = new List<Attendees>();
  static List<Attendees> newRejectedList = new List<Attendees>();
 
 // final CollectionReference attendeesCollection =
 //     Firestore.instance.collection("attends");

  ActivityService service;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title: AppLocalizations.of(context)
                .translate('activityAttendeesList')),
        body: listAttendees());
  }

  Widget listAttendees() {
    widget.attendeesList.sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
        itemCount: widget.attendeesList.length,
        itemBuilder: (context, index) =>
            attendeeCard(widget.attendeesList[index], index));
  }

  Widget attendeeCard(Attendees attendee, int index) {
     return attendCard(attendee);
  }

  Widget attendCard(attendee) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      elevation: 5,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 200.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 198,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: this.getStatusColor(attendee.statusEnum)),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MemberProileTabbar(
                        member: attendee.member,
                      );
                    }))
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 150,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CommonWidgets.instance.showMemberImage(context, attendee.member),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.teal),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: CommonWidgets.instance.showMemberNameSurname(context,
                                          attendee.member),
                                    ),
                                  ),
                                ]),
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(children: <Widget>[
                            Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 80,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      flex: 1,
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          child: CommonWidgets.instance.showAttendeeMessage(context,
                                              attendee.message!=null ?  attendee.message : ""),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                           Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 80,
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      flex: 1,
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          child: CommonWidgets.instance.showAttendeeResponseMessage(context,
                                              attendee.responseMessage!=null ?  attendee.responseMessage : ""),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          )
                          ],
                          ) 
                       ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 50,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                showStatus(attendee),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Activity
            ],
          )),
    );
  }

  Color getStatusColor(ActivityAttendStatusEnum statusEnum) {
    switch (statusEnum) {
      case ActivityAttendStatusEnum.WAITING:
        return Theme.of(context).primaryColorLight;
      case ActivityAttendStatusEnum.APPROVED:
        return Theme.of(context).primaryColor;
      case ActivityAttendStatusEnum.REJECTED:
        return Theme.of(context).primaryColorDark;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  Widget showStatus(Attendees attendee) {
    switch (attendee.statusEnum) {
      case ActivityAttendStatusEnum.WAITING:
        return Tooltip(
            message: attendee.enumToString(), child: Icon(Icons.schedule));
      case ActivityAttendStatusEnum.APPROVED:
        return Row(children: <Widget>[
          Icon(Icons.done),
        ]);
      case ActivityAttendStatusEnum.REJECTED:
        return Row(children: <Widget>[
          Icon(Icons.clear),
        ]);
    }
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.thumb_down,
              color: Colors.white,
            ),
            Text(
              " Red",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.thumb_up,
              color: Colors.white,
            ),
            Text(
              " Kabul",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  void _setAttendeeStatus(DismissDirection direction, Attendees attendee,int index) {
    if (direction == DismissDirection.startToEnd) {
      attendee.statusEnum = ActivityAttendStatusEnum.APPROVED;
    } else if (direction == DismissDirection.endToStart) {
      attendee.statusEnum = ActivityAttendStatusEnum.REJECTED;
    }

    attendsReference
        .child(attendee.key)
        .set(attendee.toJson())
        .then((value) => setState(() {
            widget.attendeesList.removeAt(index);
              print("dsfds");
            }));
  }
}
