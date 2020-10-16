import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Validators {
 
 static Validators instance = Validators._privateConstructor();
 Validators._privateConstructor();

  bool isValidAfterDate(String dob) {
    DateTime nowDate = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day); 

    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && (d.isAtSameMomentAs(nowDate) || d.isAfter(nowDate));
  }

  bool isValidBeforeDate(String dob) {
     DateTime nowDate = new DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day); 

     if (dob.isEmpty) return true;
     var d = convertToDate(dob);
     return d != null && (d.isAtSameMomentAs(nowDate) || d.isBefore(nowDate));
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

   int convertFromDateToMillisecond(DateTime date) {
    try {
      return date.millisecondsSinceEpoch;
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

  TimeOfDay convertToTimeOfDay(String input) {
    if (input == null || input.isEmpty) return null;
    try { 
      final format = DateFormat.jm("tr"); //"6:00 AM"
      return TimeOfDay.fromDateTime(format.parse(input));
    } catch (e) {
      return null;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm("tr"); //"6:00 AM"
    return format.format(dt);
  }
 
 bool isValidTime(String time) {
    if (time.isEmpty) return false;

    return true;
  }

}