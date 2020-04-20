
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:letstogether/core/model/authentication/firebase_auth_error.dart';
import 'package:letstogether/core/model/authentication/firebase_auth_success.dart';
import 'package:letstogether/core/model/authentication/user_request.dart'; 

class UsersService {

static const String FIREBASE_AUTH_URL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAXDUPGPZFwoAxhZ2fFey87qqAVMS7aZwk";
  
   
  Future postUser(UserRequest request) async { 
    var jsonModel = json.encode(request.toJson());
    final response = await http.post(FIREBASE_AUTH_URL, body: jsonModel);

    switch (response.statusCode) {
      case HttpStatus.ok:
        var successJson = json.decode(response.body);
        var success = FirebaseAuthSuccess.fromJson(successJson);
        return success;
     default:
        var errorJson = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorJson);
        return error;
    }
  }
}

