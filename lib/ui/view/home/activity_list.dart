import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/member.dart'; 
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_cards.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/drawer_page.dart';
import 'package:letstogether/ui/other/activity_screen.dart'; 
import 'package:http/http.dart' as http;  
import 'package:letstogether/core/services/activity/activity_service_creator.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';

class ActivityList extends StatefulWidget {

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  const ActivityList({Key key, this.auth, this.logoutCallback, this.userId}) : super(key: key);

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final activityReference =
    FirebaseDatabase.instance.reference().child('activity');
    
  List<Activity> activityList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var _todoQuery;
  
  ActivityService service;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  @override
  void initState() {
    super.initState();
    service = ActivityServiceCreator.instance;
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        appBar: AppBarPage(title: AppLocalizations.of(context).translate('activityList')),
        drawer: DrawerPage(auth: widget.auth, ),
        // body: Center(child: SwipeList()));
        body: activityListBuilder,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _fabButton);
  }
 
  Widget get activityListBuilder => FutureBuilder(
        future: service.getActivityList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data is List) {
                 return _listActivity(snapshot.data);
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

  Widget _listActivity(List<dynamic> list) {
    activityList = list;
    activityList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return ListView.builder(
        itemCount: activityList.length,
        itemBuilder: (context, index) =>
            CommonCards.instance.activityCard(activityList[index],context,false));
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
  
