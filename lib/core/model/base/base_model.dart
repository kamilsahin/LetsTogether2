import 'package:intl/intl.dart';

abstract class BaseModel {
  fromJson(Map<String, dynamic> json, [String key]);
  Map<String, dynamic> toJson();

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat('dd-MM-yyyy').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  String convertFromDate(DateTime date) {
    try {
      var d = new DateFormat('dd-MM-yyyy').format(date);
      return d;
    } catch (e) {
      return null;
    }
  }
  
}