import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Validators {
 
 static Validators instance = Validators._privateConstructor();
 Validators._privateConstructor();

 bool isValidAfterDate(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isAfter(new DateTime.now());
  }

  bool isValidBeforeDate(String dob) {
     if (dob.isEmpty) return true;
     var d = convertToDate(dob);
     return d != null && d.isBefore(new DateTime.now());
   }
 
   bool isValidPhoneNumber(String input) {
     final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
     return regex.hasMatch(input);
   }
 
   bool isValidEmail(String input) {
     final RegExp regex = new RegExp(
         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
     return regex.hasMatch(input);
   }
 
 
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

  TimeOfDay convertToTimeOfDay(String input) {
    if (input == null || input.isEmpty) return null;
    try {
      final format = DateFormat.jm(); //"6:00 AM"
      return TimeOfDay.fromDateTime(format.parse(input));
    } catch (e) {
      return null;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
 
 bool isValidTime(String time) {
    if (time.isEmpty) return false;

    return true;
  }

}