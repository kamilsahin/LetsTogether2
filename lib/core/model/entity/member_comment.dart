import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/model/base/base_model.dart';
import 'package:letstogether/core/model/entity/member.dart';

class MemberComment extends BaseModel {
  
  String _key; 
  String toMemberId;
  String fromMemberId;
  String comment; 
  DateTime date; 
  String time; 
  String dateStr;  
  int point; 
  Member fromMember;
  Member toMember;

  String get key => _key;
  
  MemberComment();

   MemberComment.fromJson(Map<String, dynamic> json , [String key]) {
    this._key = key;
    this.toMemberId = json['toMemberId'];
    this.fromMemberId = json['fromMemberId']; 
    this.comment = json['comment']; 
    this.date = this.convertToDate(json['date']);
    this.time = json['time'];
    this.point = json['point']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key; 
    data['toMemberId'] = this.toMemberId;
    data['fromMemberId'] = this.fromMemberId;
    data['comment'] = this.comment; 
    data['date'] =  this.convertFromDate(this.date);
    data['time'] = this.time; 
    data['point'] = this.point; 
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json,[String key]) {
    return MemberComment.fromJson(json, key);
  }

  MemberComment.map(dynamic obj) { 
    this._key = obj['id']; 
    this.fromMemberId = obj['fromMemberId'];
    this.toMemberId = obj['toMemberId'];
    this.comment = obj['comment']; 
    this.date = this.convertToDate(obj['date']);
    this.dateStr = obj['date'];
    this.time = obj['time'];
    this.point = obj['point'];  
  }
 
 
  MemberComment.fromSnapshot(DataSnapshot snapshot) {
    this._key =snapshot.key; 
    this.fromMemberId = snapshot.value['fromMemberId'];
    this.toMemberId = snapshot.value['toMemberId'];
    this.comment = snapshot.value['comment'];
    this.date = this.convertToDate(snapshot.value['date']);
    this.dateStr = snapshot.value['date'];
    this.time = snapshot.value['time'];
    this.point = snapshot.value['point'];  
  }


}