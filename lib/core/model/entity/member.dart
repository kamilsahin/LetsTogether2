import 'package:letstogether/core/model/base/base_model.dart';

class Member extends BaseModel {
  String key;
  String name;
  String surname;
  String birthday;
  int gender;
  String phoneNumber;
  String phoneNumber2;
  String disctrict;
  String city;
  String country;
  String imageUrl;

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
        this.imageUrl});

  @override
  Member.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    surname = json['surname'];
    birthday = json['birthday'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    phoneNumber2 = json['phoneNumber2'];
    disctrict = json['disctrict'];
    city = json['city'];
    country = json['country'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumber2'] = this.phoneNumber2;
    data['disctrict'] = this.disctrict;
    data['city'] = this.city;
    data['country'] = this.country;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Member.fromJson(json);
  }

}