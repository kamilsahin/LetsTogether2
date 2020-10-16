import 'package:cloud_firestore/cloud_firestore.dart';
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
  String birthdayStr;
  String about;
  String hobies;
  String instagram;
  String twitter;
  String facebook;
  String website;
  double avgPoint;

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
        this.userId,
        this.about,
        this.hobies,
        this.instagram,
        this.twitter,
        this.facebook,
        this.website,
        this.avgPoint });

  @override
  Member.fromJson(Map<dynamic, dynamic> json,[String key]) {
    this.key = key;
    this.name = json['name'];
    this.surname = json['surname'];
    this.birthday = this.convertToDate(json['birthday']);
    this.birthdayStr = json['birthday'];
    this.gender = json['gender'];
    this.phoneNumber = json['phoneNumber'];
    this.phoneNumber2 = json['phoneNumber2'];
    this.disctrict = json['disctrict'];
    this.city = json['city'];
    this.country = json['country'];
    this.imageUrl = json['imageUrl'];
    this.userId = json['userId'];
    this.about = json['about'];
    this.hobies = json['hobies'];
    this.instagram = json['instagram'];
    this.twitter = json['twitter'];
    this.facebook = json['facebook'];
    this.website = json['website'];
   // this.avgPoint = json['avgPoint'];
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['surname'] = this.surname; 
    data['birthday'] =  this.convertFromDate(this.birthday);
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumber2'] = this.phoneNumber2;
    data['disctrict'] = this.disctrict;
    data['city'] = this.city;
    data['country'] = this.country;
    data['imageUrl'] = this.imageUrl;
    data['userId'] = this.userId;
    data['about'] = this.about;
    data['hobies'] = this.hobies;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['website'] = this.website;
   // data['avgPoint'] = this.avgPoint;
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
    this.birthday = this.convertToDate(snapshot.value['birthday']);
    this.birthdayStr = snapshot.value['birthday'];
    this.gender = snapshot.value['gender'];
    this.phoneNumber = snapshot.value['phoneNumber'];
    this.phoneNumber2 = snapshot.value['phoneNumber2'];
    this.disctrict = snapshot.value['disctrict'];
    this.city = snapshot.value['city'];
    this.country = snapshot.value['country'];
    this.imageUrl = snapshot.value['imageUrl'];
    this.userId = snapshot.value['userId'];
    this.about = snapshot.value['about'];
    this.hobies = snapshot.value['hobies'];
    this.instagram = snapshot.value['instagram'];
    this.twitter = snapshot.value['twitter'];
    this.facebook = snapshot.value['facebook'];
    this.website = snapshot.value['website'];
  //  this.avgPoint = snapshot.value['avgPoint'];
  }

  Member.fromSnapshott(DocumentSnapshot snapshot) {
    //this.key =snapshot.data.keys;
    this.name = snapshot.data['name'];
    this.surname = snapshot.data['surname']; 
    this.birthday = this.convertToDate(snapshot.data['birthday']);
    this.birthdayStr = snapshot.data['birthday'];
    this.gender = snapshot.data['gender'];
    this.phoneNumber = snapshot.data['phoneNumber'];
    this.phoneNumber2 = snapshot.data['phoneNumber2'];
    this.disctrict = snapshot.data['disctrict'];
    this.city = snapshot.data['city'];
    this.country = snapshot.data['country'];
    this.imageUrl = snapshot.data['imageUrl'];
    this.userId = snapshot.data['userId'];
    this.about = snapshot.data['about'];
    this.hobies = snapshot.data['hobies'];
    this.instagram = snapshot.data['instagram'];
    this.twitter = snapshot.data['twitter'];
    this.facebook = snapshot.data['facebook'];
    this.website = snapshot.data['website'];
  //  this.avgPoint = snapshot.data['avgPoint'];
  }
      
}