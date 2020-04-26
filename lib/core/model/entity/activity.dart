import 'package:firebase_database/firebase_database.dart'; 
import 'package:letstogether/core/model/base/base_model.dart';
import 'package:letstogether/core/model/entity/member.dart';


class Activity extends BaseModel {
  
  String _key;
  String memberId;
  String header;
  String description;
  DateTime date;
  String disctrict;
  String city;
  String country;
  String imageUrl;
  String time;
  String dateStr;
  Member _createMember;

  Member get createMember => _createMember;

  set createMember(Member createMember) {
    _createMember = createMember;
  }

  String get key => _key;
  /*   
  Activity( this._key,
      this.memberId,
      this.header,
      this.description,
      this.date,
      this.disctrict,
      this.city,
      this.country,
      this.imageUrl );
*/

  Activity();

  Activity.fromJson(Map<String, dynamic> json , [String key]) {
    this._key = key;
    this.memberId = json['memberId'];
    this.header = json['header'];
    this.description = json['description'];
    this.date = this.convertToDate(json['date']);
    this.time = json['time'];
    this.dateStr = json['date'];
    this.disctrict = json['disctrict'];
    this.city = json['city'];
    this.country = json['country'];
    this.imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['memberId'] = this.memberId;
    data['header'] = this.header;
    data['description'] = this.description;
    data['date'] =  this.convertFromDate(this.date);
    data['time'] = this.time;
    data['disctrict'] = this.disctrict;
    data['city'] = this.city;
    data['country'] = this.country;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json,[String key]) {
    return Activity.fromJson(json, key);
  }

  Activity.map(dynamic obj) { 
    this._key = obj['id'];
    this.memberId = obj['memberId'];
    this.header = obj['header'];
    this.description = obj['description'];
    this.date = this.convertToDate(obj['date']);
    this.dateStr = obj['date'];
    this.time = obj['time'];
    this.disctrict = obj['disctrict'];
    this.city = obj['city'];
    this.country = obj['country'];
    this.imageUrl = obj['imageUrl'];
  }
 
 
  Activity.fromSnapshot(DataSnapshot snapshot) {
    this._key =snapshot.key;
    this.memberId = snapshot.value['memberId'];
    this.header = snapshot.value['header'];
    this.description = snapshot.value['description'];
    this.date = this.convertToDate(snapshot.value['date']);
    this.dateStr = snapshot.value['date'];
    this.time = snapshot.value['time'];
    this.disctrict = snapshot.value['disctrict'];
    this.city = snapshot.value['city'];
    this.country = snapshot.value['country'];
    this.imageUrl = snapshot.value['imageUrl'];
  }


}
