import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/model/base/base_model.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';

class Attendees extends BaseModel {
 
  String _key;
  String activityId;
  String memberId;
  String message; 
  DateTime date; 
  String time;
  int status;
  String dateStr;
  ActivityAttendStatusEnum statusEnum;
  Activity activity;
  Member member;
  String responseMessage; 


  Attendees _createAttendee;

  Attendees get createAttendee => _createAttendee;

  set createAttendee(Attendees createAttendee) {
    _createAttendee = createAttendee;
  }

  String get key => _key;
  
  Attendees();

  Attendees.fromJson(Map<String, dynamic> json , [String key]) {
    this._key = key;
    this.activityId = json['activityId'];
    this.memberId = json['memberId'];
    this.message = json['message']; 
    this.date = this.convertToDate(json['date']);
    this.time = json['time'];
    this.status = json['status'];
    this.statusEnum =   this.numberToEnum(json['status']);
    this.responseMessage = json['responseMessage']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['activityId'] = this.activityId;
    data['memberId'] = this.memberId;
    data['message'] = this.message; 
    data['date'] =  this.convertFromDate(this.date);
    data['time'] = this.time;
    data['status'] = this.enumToNumber(this.statusEnum); 
    data['responseMessage'] = this.responseMessage; 
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json,[String key]) {
    return Attendees.fromJson(json, key);
  }

  Attendees.map(dynamic obj) { 
    this._key = obj['id'];
    this.activityId = obj['activityId'];
    this.memberId = obj['memberId'];
    this.message = obj['message']; 
    this.date = this.convertToDate(obj['date']);
    this.dateStr = obj['date'];
    this.time = obj['time'];
    this.status = obj['status']; 
    this.statusEnum =   this.numberToEnum(obj['status']);
    this.responseMessage = obj['responseMessage']; 
  }
 
 
  Attendees.fromSnapshot(DataSnapshot snapshot) {
    this._key =snapshot.key;
    this.activityId = snapshot.value['activityId'];
    this.memberId = snapshot.value['memberId'];
    this.message = snapshot.value['message'];
    this.date = this.convertToDate(snapshot.value['date']);
    this.dateStr = snapshot.value['date'];
    this.time = snapshot.value['time'];
    this.status = snapshot.value['status']; 
    this.statusEnum =   this.numberToEnum(snapshot.value['status']);
  }


enumToNumber(ActivityAttendStatusEnum enumVal){
  switch (enumVal) {
    case ActivityAttendStatusEnum.WAITING:
      return 1;
    case ActivityAttendStatusEnum.APPROVED:
      return 2;
    case ActivityAttendStatusEnum.REJECTED:
      return 3;
     
    default:
      return 1;
  }
}

  numberToEnum(int val){
  switch (val) {
    case 1:
      return ActivityAttendStatusEnum.WAITING;
    case 2:
      return ActivityAttendStatusEnum.APPROVED;
    case 3:
      return ActivityAttendStatusEnum.REJECTED;
     
    default:
      return ActivityAttendStatusEnum.WAITING;
  }
}

enumToString(){
  switch (this.statusEnum) {
    case ActivityAttendStatusEnum.WAITING:
      return "Beklemede";
    case ActivityAttendStatusEnum.APPROVED:
      return "Onaylandı";
    case ActivityAttendStatusEnum.REJECTED:
      return "Reddedildi"; 
   default:
      return 1;
  }
}

}
