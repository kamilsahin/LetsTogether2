import 'dart:convert';
import 'dart:io';

import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/authentication/firebase_auth_error.dart';
import 'package:letstogether/core/model/base/base_header.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/services/base_service.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class ActivityService {
   static const String FIREBASE_URL = "https://letstogether-7fad5.firebaseio.com/";

   BaseService _baseService = BaseService.instance;
  
   Future getActivityList() async {
        var response = await _baseService.get<Activity>(Activity(), "activity",
        header: Header(
            "auth", SharedManager.instance.getStringValue(SharedKeys.TOKEN)));
    if (response is List<Activity>) {
      print("okey");
    } else {
      Logger().e(response);
    }
    return response; 
  }

   Future postActivity(Activity request) async {
    var jsonModel = json.encode(request.toJson());
    final response = await http.post(FIREBASE_URL, body: jsonModel);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
      default:
        var errorJson = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorJson);
        return error;
    }
  }

  
}