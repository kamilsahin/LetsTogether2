import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';
import 'package:letstogether/ui/base/validators.dart';

class ActivityServiceReal implements ActivityService {
   
  final activityReference =
      FirebaseDatabase.instance.reference().child('activity');
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Firestore _fireStore = Firestore.instance;

   void setActivityToDB(newKey , newActivity) {
      activityReference.child(newKey).set(newActivity.toJson());
   }
 
   Future getActivityKey() async { 
      return activityReference.child('activity').push().key;
   }

   Stream<DataSnapshot> getActivityListByCity(cityId)
   {
     return activityReference.child("district")
            .orderByChild("city_id")
            .equalTo(cityId)
            .once()
            .asStream();
   }
    
  Future getActivityList() async {

    String cityId = SharedManager.instance.getStringValue(SharedKeys.CITY);

    int dateTime = Validators.instance.convertFromDateToMillisecond(DateTime.now());
    List<Activity> activityList = new List();
    await activityReference
        .orderByChild("dateTime")
        .startAt(dateTime)
        .once()
        .then((DataSnapshot value) async {
      if (value.value != null) {
        var keys = value.value.keys;
        var data = value.value;
        for (var key in keys) { 
          var json = new Map<String, dynamic>.from(data[key]);
          Activity activity = new Activity.fromJson(json, key);
         if(activity.city == cityId)
         {
           Member createMember;
          await _database
              .reference()
              .child("member/${activity.memberId}")
              .once()
              .then((value) {
            createMember = Member.fromSnapshot(value);
            activity.createMember = createMember;
            activityList.add(activity);
          });
         }
        }
      }
    });
    return activityList;
  }

  Future getActivityListByMemberId(String memberKey,bool future) async {
    List<Activity> activityList = new List();
    int dateTime = Validators.instance.convertFromDateToMillisecond(DateTime.now());

    await activityReference
        .orderByChild("memberId")
        .equalTo(memberKey)
        .once()
        .then((DataSnapshot value) async {
      var keys = value.value.keys;
      var data = value.value;
      for (var key in keys) {
        var json = new Map<String, dynamic>.from(data[key]);
        Activity activity = new Activity.fromJson(json, key);

        if(activity.dateTime!=null && (!future || ( future && activity.dateTime > dateTime)))
        {
           Member createMember;
          await _database
              .reference()
              .child("member/${activity.memberId}")
              .once()
              .then((value) {
            createMember = Member.fromSnapshot(value);
            activity.createMember = createMember;
            activityList.add(activity);
        });
        }
       
      }
    });
    return activityList;
  }


}
