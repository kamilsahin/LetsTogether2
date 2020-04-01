import 'package:letstogether/core/model/base/base_model.dart';

class Activity extends BaseModel {
  String key;
  String memberId;
  String header;
  String description;
  String date;
  String disctrict;
  String city;
  String country;
  String imageUrl;

  Activity(
      {this.key,
        this.memberId,
      this.header,
      this.description,
      this.date,
      this.disctrict,
      this.city,
      this.country,
      this.imageUrl});

  Activity.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    memberId = json['memberId'];
    header = json['header'];
    description = json['description'];
    date = json['date'];
    disctrict = json['disctrict'];
    city = json['city'];
    country = json['country'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['memberId'] = this.memberId;
    data['header'] = this.header;
    data['description'] = this.description;
    data['date'] = this.date;
    data['disctrict'] = this.disctrict;
    data['city'] = this.city;
    data['country'] = this.country;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Activity.fromJson(json);
  }
}
