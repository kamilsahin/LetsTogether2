import 'dart:convert';
import 'dart:io';

import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/authentication/firebase_auth_error.dart';
import 'package:letstogether/core/model/base/base_header.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'base_service.dart';

class MemberService {
  
  static const String FIREBASE_URL = "https://letstogether-7fad5.firebaseio.com/";

   BaseService _baseService = BaseService.instance;
  
   Future getMemberList() async {
        var response = await _baseService.get<Member>(Member(), "member",
        header: Header(
            "auth", SharedManager.instance.getStringValue(SharedKeys.TOKEN)));
    if (response is List<Member>) {
      print("okey");
    } else {
      Logger().e(response);
    }
    return response; 
  }

   Future postMember(Member request) async {
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