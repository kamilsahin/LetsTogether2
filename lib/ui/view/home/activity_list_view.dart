import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/services/activity_service.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/drawer_page.dart';
import 'package:letstogether/ui/other/activity_screen.dart';
import 'package:letstogether/ui/view/home/activity_detail.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/view/home/member_profile_tabbar.dart';

class ActivityListView extends StatefulWidget {
  ActivityListView({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _ActivityListViewState createState() => _ActivityListViewState();
}

final activityReference =
    FirebaseDatabase.instance.reference().child('activity');

class _ActivityListViewState extends State<ActivityListView> {
  List<Activity> activityList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var _todoQuery;

  StreamSubscription<Event> _onActivityAddedSubscription;
  StreamSubscription<Event> _onActivityChangedSubscription;

  ActivityService service;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  @override
  void initState() {
    super.initState();
    service = ActivityService();

    activityList = new List();
    _todoQuery = _database.reference().child("activity");

    _todoQuery.once();
/*
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child("einstein-1.png");
    storageRef.getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl = fileURL;
      });
    });*/

    _onActivityAddedSubscription =
        activityReference.onChildAdded.listen(_onActivityAdded);
    _onActivityChangedSubscription =
        activityReference.onChildChanged.listen(_onActivityUpdated);

/*
        var query = FirebaseDatabase.instance
            .reference()
            .child("activity")
            .orderByChild("userId");
        
        var snapshot = await query.once();
        var keys = snapshot.value.keys;
        var data = snapshot.value;

        for (var key in keys) {
          var json = new Map<String, dynamic>.from(data[key]);
          Activity activity = new Activity.fromJson(json, key); 
          activityList.add(activity);
        }*/
  }

  @override
  void dispose() {
    _onActivityAddedSubscription.cancel();
    _onActivityChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(title: "Aktivite Listesi"),
        drawer: DrawerPage(
            auth: widget.auth, logoutCallback: widget.logoutCallback),
        // body: Center(child: SwipeList()));
        body: _listActivity(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _fabButton);
  }
 
  Widget get _fabButton => FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/activityCreate");
        },
        child: Icon(Icons.add),
      );
  /*
      Widget get activityListBuilder => FutureBuilder(
            future: service.getActivityList(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    if (snapshot.data is List) {
                      return _listActivity(snapshot.data);
                    } else if (snapshot.data is Response) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await SharedManager.instance
                            .saveString(SharedKeys.TOKEN, "");
                        Navigator.of(context).pop();
                      });
                    }
                  }
                  return _notFoundWidget;
    
                default:
                  return _waitingWidget;
              }
            },
          );
    
      Widget _listActivity(List<Activity> list) {
        return ListView.builder(
            itemCount: activityList.length,
            itemBuilder: (context, index) => _activityCard(activityList[index]));
      }*/

  Widget _listActivity() {
    activityList.sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
        itemCount: activityList.length,
        itemBuilder: (context, index) =>
            _activityCard(activityList[index], index));
  }

  Widget _activityCard(Activity activity, int index) {
    var activityid = activity.key;
    return Dismissible(
      key: Key(activityid),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) async {
        _deleteActivity(activityid, index);
      },
      child: Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 5,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            height: 222.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
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
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    showMemberImage(activity),
                                  ]),
                            )),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                showMemberNameSurname(activity),
                              ],
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
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: showActivityHeader(activity),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                                  new Expanded(
                                    flex: 1,
                                    child: new SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child: showActivityDescr(activity),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      showActivityImage(activity),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 3),
                                        child: Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.teal),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: showActivityDate(activity),
                                        ),
                                      ),
                                    ]),
                              )),
                        ],
                      ),
                    ))
              ],
            )),
      ),
    );
  }

  Widget showMemberImage(activity) {
    return Hero(
      tag: "activityMemberImage${activity.key}}",
      transitionOnUserGestures: false,
      child: Container(
        width: 60.0,
        height: 45.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(activity.createMember.imageUrl != null
                    ? activity.createMember.imageUrl
                    : emptyImageUrl))),
      ),
    );
  }

  Widget showMemberNameSurname(activity) {
    return Hero(
      tag: "activityCMemName${activity.key}",
      child: Text(
        activity.createMember != null
            ? activity.createMember.name + " " + activity.createMember.surname
            : "Ad Soyad",
      ),
    );
  }

  Widget showActivityHeader(activity) {
    return Hero(
      tag: "activityHeader${activity.key}",
      child: Text(activity.header,
          maxLines: 2, style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget showActivityDescr(activity) {
    return Hero(
      tag: "activityDescr${activity.key}",
      child: Text(
        activity.description,
        maxLines: null,
        style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 48, 48, 54)),
      ),
    );
  }

  Widget showActivityImage(activity) {
    return Hero(
      tag: "activityImage${activity.key}",
      transitionOnUserGestures: false,
      child: Container(
        width: 120.0,
        height: 90.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(activity.imageUrl != null
                    ? activity.imageUrl
                    : emptyImageUrl))),
      ),
    );
  }

  Widget showActivityDate(activity) {
    return Hero(
      tag: "activityDate${activity.key}",
      transitionOnUserGestures: false,
      child: Text(
        activity.dateStr,
        textAlign: TextAlign.center,
      ),
    );
  }
 
  Future<void> _onActivityAdded(Event event) async { 
    Activity actv = new Activity.fromSnapshot(event.snapshot);
    setState(() {
     setMemberProd(actv);
    }); 
  }

  Future<void> setMemberProd(actv) async
  {
     Member actvMem;
     await _database
        .reference()
        .child("member/" + actv.memberId)
        .once()
        .then((value) {
          setState(() {
            actvMem = new Member.fromSnapshot(value);
          });
        });  
        
    actv.createMember = actvMem; 
    activityList.add(actv);
  }

  void _onActivityUpdated(Event event) {
    var oldActivityValue = activityList
        .singleWhere((activity) => activity.key == event.snapshot.key);
    setState(() {
      activityList[activityList.indexOf(oldActivityValue)] =
          new Activity.fromSnapshot(event.snapshot);
    });
  }

  void _deleteActivity(String activityId, int position) async {
    await activityReference.child(activityId).remove().then((_) {
      setState(() {
        activityList.removeAt(position);
      });
    });
  }

  void _navigateToActivity(BuildContext context, Activity activity) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActivityScreen(activity)),
    );
  }

  void _createNewActivity(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityScreen(Activity()),
        ));
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
