import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letstogether/ui/base/validators.dart';

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

  int convertFromDateToMillisecond(DateTime date, String time) {
    try {
      TimeOfDay timeofDay =  Validators.instance.convertToTimeOfDay(time);
      final dt = DateTime(date.year, date.month, date.day, timeofDay.hour, timeofDay.minute);
      return dt.millisecondsSinceEpoch;
    } catch (e) {
      return null;
    }
  }

   DateTime convertFromMillisecondToDate(int dateMilisecond) {
    try { 
      DateTime date =  DateTime.fromMicrosecondsSinceEpoch(dateMilisecond);
      return date;
    } catch (e) {
      return null;
    }
  }




 
}