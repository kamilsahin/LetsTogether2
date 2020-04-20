import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/model/base/base_model.dart';

class Member extends BaseModel {
  String key;
  String name;
  String surname;
  DateTime birthday;
  int gender;
  String phoneNumber;
  String phoneNumber2;
  String disctrict;
  String city;
  String country;
  String imageUrl;
  String userId;

  Member(
      {this.key,
        this.name,
        this.surname,
        this.birthday,
        this.gender,
        this.phoneNumber,
        this.phoneNumber2,
        this.disctrict,
        this.city,
        this.country,
        this.imageUrl,
        this.userId});

  @override
  Member.fromJson(Map<dynamic, dynamic> json,[String key]) {
    this.key = key;
    this.name = json['name'];
    this.surname = json['surname'];
   // birthday = json['birthday'];
    this.gender = json['gender'];
    this.phoneNumber = json['phoneNumber'];
    this.phoneNumber2 = json['phoneNumber2'];
    this.disctrict = json['disctrict'];
    this.city = json['city'];
    this.country = json['country'];
    this.imageUrl = json['imageUrl'];
    this.userId = json['userId'];
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['birthday'] = this.birthday.toString();
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumber2'] = this.phoneNumber2;
    data['disctrict'] = this.disctrict;
    data['city'] = this.city;
    data['country'] = this.country;
    data['imageUrl'] = this.imageUrl;
    data['userId'] = this.userId;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json,[String key]) {
    return Member.fromJson(json, key);
  }

  Member.fromSnapshot(DataSnapshot snapshot) {
    this.key =snapshot.key;
    this.name = snapshot.value['name'];
    this.surname = snapshot.value['surname'];
   // birthday = snapshot.value['birthday'];
    this.gender = snapshot.value['gender'];
    this.phoneNumber = snapshot.value['phoneNumber'];
    this.phoneNumber2 = snapshot.value['phoneNumber2'];
    this.disctrict = snapshot.value['disctrict'];
    this.city = snapshot.value['city'];
    this.country = snapshot.value['country'];
    this.imageUrl = snapshot.value['imageUrl'];
    this.userId = snapshot.value['userId'];
  }
      
}