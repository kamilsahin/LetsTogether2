import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/attendees.dart';
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';
import 'package:letstogether/core/services/attendees_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/drawer_page.dart';
import 'package:letstogether/ui/view/home/activity_detail.dart';
import 'package:letstogether/ui/view/home/member_profile_tabbar.dart';
import 'package:letstogether/ui/view/home/activity_messages.dart';
import 'package:http/http.dart' as http;

class MyJoinedActivities extends StatefulWidget {
  MyJoinedActivities({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _MyJoinedActivitiesState createState() => _MyJoinedActivitiesState();
}

class _MyJoinedActivitiesState extends State<MyJoinedActivities> {
  List<Attendees> attendeesList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final attendsReference =
      FirebaseDatabase.instance.reference().child('attends');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _memberKey = "";
  AttendeesService service;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  @override
  void initState() {
    super.initState();
    service = AttendeesService();
    attendeesList = new List();
    _memberKey = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
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
                AppLocalizations.of(context).translate('myJoinedActivities')),
        drawer: DrawerPage(auth: widget.auth, ),
        // body: Center(child: SwipeList()));
        body: joinedActivityBuilder);
  }

  Widget get joinedActivityBuilder => FutureBuilder(
        future: service.getActivityListByJoinedMemberId(_memberKey,true,false),
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
            _activityCard(attendeesList[index], index));
  }

  Widget _activityCard(Attendees attendee, int index) {
    Activity activity = attendee.activity;
    return Card(
      color: Theme.of(context).cardTheme.color,
      elevation: 5,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 222.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: this.getStatusColor(attendee.statusEnum)),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MemberProileTabbar(
                        member: activity.createMember,
                      );
                    }))
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CommonWidgets.instance.showActivityMemberImage(context, activity),
                                ]),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Expanded(
                                    flex: 1,
                                    child: new  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child : CommonWidgets.instance.showActivityMemberNameSurname(context, activity)
                                 )
                                 )
                             ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 50,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                showStatus(context, activity, attendee),
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
              GestureDetector(
                  onTap: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ActivityDetail(
                            activity: activity,
                            imageUrl: activity.imageUrl,
                          );
                        }))
                      },
                  child: Container(
                    //  color: Theme.of(context).primaryColorLight,
                    height: 170,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: CommonWidgets.instance.showActivityHeader(context, activity),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                                new Expanded(
                                  flex: 1,
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                      child:  CommonWidgets.instance.showActivityDescr(context,activity),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                     CommonWidgets.instance.showActivityImage(context,activity),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.teal),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child:  CommonWidgets.instance.showActivityDate(context,activity),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child: Container(
                                        width: 60,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.red),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child:  CommonWidgets.instance.showActivityTime(context,activity),
                                      ),
                                    )
                                  ]),
                            )),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
 
  Widget showStatus(context, activity, attendee) {
    switch (attendee.statusEnum) {
      case ActivityAttendStatusEnum.WAITING:
        return Tooltip(
            message: attendee.enumToString(), child: Icon(Icons.schedule));
      case ActivityAttendStatusEnum.APPROVED:
        return showMessagesButton(context, activity, attendee);
      case ActivityAttendStatusEnum.REJECTED:
        return Row(children: <Widget>[
          Icon(Icons.clear),
        ]);
    }
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

  Widget showMessagesButton(context, activity, attendee) {
    return new Visibility(
        visible: attendee.statusEnum == ActivityAttendStatusEnum.APPROVED,
        child: IconButton(
          icon: new Icon(Icons.message),
          tooltip: AppLocalizations.of(context).translate('activityMessages'),
          onPressed: (() {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              /*  return ActivityAttendeesTabbar(
                          activity: activity,
                        );*/
              return ActivityMessages(
                activity: activity,
              );
            }));
          }),
        ));
  }
}
