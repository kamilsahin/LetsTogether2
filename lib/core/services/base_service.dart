import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:letstogether/core/model/base/base_header.dart';
import 'package:letstogether/core/model/base/base_model.dart';

class BaseService {
   static const String FIREBASE_URL = "https://letstogether-7fad5.firebaseio.com";

  static BaseService _instance = BaseService._private();
  BaseService._private();

  static BaseService get instance => _instance;

  Future get<T extends BaseModel>(T model, String child,
      {Header header}) async {
    final response = await http
        .get("$FIREBASE_URL/$child.json?${header.key}=${header.value}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(response.body);

        if (jsonModel is Map) {
          if (jsonModel.length > 1) {
            List<T> list = [];
            jsonModel.forEach((key, value) {
               list.add(model.fromJson(value,key));
            });
            return list;
          }
          return model.fromJson(jsonModel);
        } else if (jsonModel is List) {
          return jsonModel.map((value) {
            return model.fromJson(value);
          }).toList();
        }
        return jsonModel;
      case HttpStatus.unauthorized:
      // refresh token
        return response;
    // break;
      case HttpStatus.notFound:
        return "asd";
      default:
        return response;
    }
  }
}