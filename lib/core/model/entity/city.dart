import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/model/base/base_model.dart';

class City extends BaseModel {
  
  String _key;
  String id;
  String name;
    
  City();

  String get key => _key;

  City.fromJson(Map<String, dynamic> json , [String key]) {
    this._key = key;
    this.id = json['id']; 
    this.name = json['name']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['id'] = this.id;
    data['name'] = this.name; 
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json,[String key]) {
    return City.fromJson(json, key);
  }

  City.map(dynamic obj) { 
    this._key = obj['key'];
    this.id = obj['id'];
    this.name = obj['name'];
  }
 
 
  City.fromSnapshot(DataSnapshot snapshot) {
    this._key =snapshot.key;
    this.id = snapshot.value['id'];
    this.name = snapshot.value['name']; 
  }


}