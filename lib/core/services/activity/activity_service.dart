import 'package:firebase_database/firebase_database.dart';

abstract class  ActivityService {
  
  void setActivityToDB(newKey , newActivity);
   
  Future getActivityKey();

  Stream<DataSnapshot> getActivityListByCity(cityId);

  Future getActivityList();

  Future getActivityListByMemberId(String memberKey,bool future) ;
  
}