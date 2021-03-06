import 'package:letstogether/core/model/base/base_model.dart';

class Student extends BaseModel {
  String key;
  String name;
  int number;

  Student({this.key, this.name, this.number});

  Student.fromJson(Map<String, dynamic> json, [String key]) {
    key = key;
    name = json['name'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['number'] = this.number;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json, [String key] ) {
    return Student.fromJson(json,key);
  }
}