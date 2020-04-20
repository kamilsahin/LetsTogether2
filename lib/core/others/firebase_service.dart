import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_header.dart';
import 'package:letstogether/core/model/entity/student.dart';
import 'package:letstogether/core/model/entity/user.dart';
import 'package:letstogether/core/services/base_service.dart';

class FirebaseService {
  static const String FIREBASE_URL =
      "https://letstogether-7fad5.firebaseio.com/";

  BaseService _baseService = BaseService.instance;

  Future<List<User>> getUsers() async {
    final response = await http.get("$FIREBASE_URL/user.json");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body);
        final userList = jsonModel
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<User>();
        return userList;
      default:
        return Future.error(response.statusCode);
    }
  }

  Future getStudents() async {
    var response = await _baseService.get<Student>(Student(), "students",
        header: Header(
            "auth", SharedManager.instance.getStringValue(SharedKeys.TOKEN)));
    if (response is List<Student>) {
      print("okey");
    } else {
      Logger().e(response);
    }
  }

  Future<Student> getStudent(String key) async {
    final response = await http.get("$FIREBASE_URL/student/$key.json");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body) as Map;
        if (jsonModel == null) throw NullThrownError();
        return Student.fromJson(jsonModel);

      default:
        return Future.error(response.statusCode);
    }
  }
}
