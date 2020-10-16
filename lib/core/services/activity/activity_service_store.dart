import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';
import 'package:letstogether/ui/base/validators.dart';


class ActivityServiceStore implements ActivityService {  
  
  final Firestore _fireStore = Firestore.instance;

  void setActivityToDB(newKey , newActivity) {
      _fireStore.collection("activity").document(newKey).setData(newActivity.toJson());
  }
 
   Future getActivityKey() async { 
      Activity newActivity = new Activity();
      String key = "" ;
      await _fireStore.collection("activity").add(newActivity.toJson()).then((value) async {
      print(value.documentID);
        key = value.documentID;
      });
      return key;
   }

   Stream<DataSnapshot> getActivityListByCity(cityId)
   {
      /*return activityReference.child("district")
            .orderByChild("city_id")
            .equalTo(cityId)
            .once()
            .asStream(); */
   }
    
   Future getActivityList() async {

    String cityId = SharedManager.instance.getStringValue(SharedKeys.CITY);
    int dateTime = Validators.instance.convertFromDateToMillisecond(DateTime.now());
    List<Activity> activityList = new List();
    await _fireStore
        .collection("activity")
        .getDocuments()
        .then((QuerySnapshot value) async {
      if (value != null) {
        print(value.documents[0].data["date"]); 
        for (var data in value.documents) { 
         Activity activity = new Activity.fromJson(data.data, data.documentID);
       /*  if(activity.city == cityId)
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
         }*/
         activityList.add(activity);
        }
      }
    });
    return activityList; 
  }

  Future getActivityListByMemberId(String memberKey,bool future) async {
    List<Activity> activityList = new List();
  /*  int dateTime = Validators.instance.convertFromDateToMillisecond(DateTime.now());

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
    });*/
    return activityList;
  }
}
 
