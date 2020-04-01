import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/model/entity/student.dart';
import 'package:letstogether/core/model/entity/user.dart';

import '../model/user/user_auth_error.dart';
import '../model/user/user_request.dart';

class FirebaseService {
  static const String FIREBASE_URL = "https://letstogether-7fad5.firebaseio.com/";
  static const String FIREBASE_AUTH_URL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAXDUPGPZFwoAxhZ2fFey87qqAVMS7aZwk";

//  BaseService _baseService = BaseService.instance;

  Future postUser(UserRequest request) async {
    var jsonModel = json.encode(request.toJson());
    final response = await http.post(FIREBASE_AUTH_URL, body: jsonModel);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        var errorJson = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorJson);
        return error;
    }
  }

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
 /*   var response = await _baseService.get<Student>(Student(), "students",
        header: Header(
            "auth", SharedManager.instance.getStringValue(SharedKeys.TOKEN)));
    if (response is List<Student>) {
      print("okey");
    } else {
      Logger().e(response);
    }
    return response;*/
      final response = await http.get("$FIREBASE_URL/students.json");

      switch (response.statusCode) {
       case HttpStatus.ok:
         final jsonModel = json.decode(response.body) as Map;
         final studentList = List<Student>();

         jsonModel.forEach((key, value) {
           Student student = Student.fromJson(value);
           student.key = key;
           studentList.add(student);
         });
         return studentList;

       default:
         return Future.error(response.statusCode);
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


  Future getMembers() async {
    /*   var response = await _baseService.get<Student>(Student(), "students",
        header: Header(
            "auth", SharedManager.instance.getStringValue(SharedKeys.TOKEN)));
    if (response is List<Student>) {
      print("okey");
    } else {
      Logger().e(response);
    }
    return response;*/
    print(FIREBASE_URL);
    final response = await http.get("$FIREBASE_URL/member.json");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body) as Map;
        final memberList = List<Member>();

        jsonModel.forEach((key, value) {
          Member member = Member.fromJson(value);
          member.key = key;
          memberList.add(member);
        });
        return memberList;

      default:
        return Future.error(response.statusCode);
    }
  }

  Future getActivityList() async {
    /*   var response = await _baseService.get<Student>(Student(), "students",
        header: Header(
            "auth", SharedManager.instance.getStringValue(SharedKeys.TOKEN)));
    if (response is List<Student>) {
      print("okey");
    } else {
      Logger().e(response);
    }
    return response;*/
    print(FIREBASE_URL);
    final response = await http.get("$FIREBASE_URL/activity.json");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body) as Map;
        final memberList = List<Activity>();

        jsonModel.forEach((key, value) {
          Activity activity = Activity.fromJson(value);
          activity.key = key;
          memberList.add(activity);
        });
        return memberList;

      default:
        return Future.error(response.statusCode);
    }
  }

}