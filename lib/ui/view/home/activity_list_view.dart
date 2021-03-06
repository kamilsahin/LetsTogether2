import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart'; 
import 'package:letstogether/core/services/activity/activity_service_creator.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_cards.dart';
import 'package:letstogether/ui/base/drawer_page.dart';
import 'package:letstogether/ui/base/validators.dart';
import 'package:letstogether/ui/other/activity_screen.dart';
import 'package:letstogether/core/model/entity/member.dart';

class ActivityListView extends StatefulWidget {
  ActivityListView({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _ActivityListViewState createState() => _ActivityListViewState();
}



class _ActivityListViewState extends State<ActivityListView> {
  final activityReference =
    FirebaseDatabase.instance.reference().child('activity');
    
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
    service = ActivityServiceCreator.instance;

    String dateee = Validators.instance.convertFromDate(DateTime.now());
    print(dateee);

    activityList = new List();
    _todoQuery = _database.
    reference().
    child("activity").
    orderByChild("date").
    equalTo(dateee);

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
  /*  _onActivityChangedSubscription =
        activityReference.onChildChanged.listen(_onActivityUpdated);*/

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
        appBar: AppBarPage(title: AppLocalizations.of(context).translate('activityList')),
        drawer: DrawerPage(auth: widget.auth, ),
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
            CommonCards.instance.activityCard(activityList[index],context,false));
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

  void _onActivityUpdated(Event event) async{
    var oldActivityValue = activityList
        .singleWhere((activity) => activity.key == event.snapshot.key);
    setState(() {
      Activity actv = new Activity.fromSnapshot(event.snapshot);
      setState(() {
        setMemberProd(actv);
      });
      activityList[activityList.indexOf(oldActivityValue)] = actv;
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
