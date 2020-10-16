import 'package:flutter/material.dart'; 
import 'package:letstogether/core/model/entity/attendees.dart';  
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/view/home/activity_attendees.dart'; 

class ActivityAttendeesRejected extends ActivityAttendees {
  ActivityAttendeesRejected({this.attendeesList});
 
  final List<Attendees> attendeesList;

  @override
  _ActivityAttendeesRejectedState createState() => _ActivityAttendeesRejectedState();
}

class _ActivityAttendeesRejectedState extends ActivityAttendeesState {
 
 // final CollectionReference attendeesCollection =
 //     Firestore.instance.collection("attends");

  @override
  void initState() {
    super.initState();
    if(ActivityAttendeesState.newRejectedList!=null)
    {
      widget.attendeesList.addAll(ActivityAttendeesState.newRejectedList);
      ActivityAttendeesState.newRejectedList.clear();
    }
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title: AppLocalizations.of(context)
                .translate('activityAttendeesRejected')),
        body: listAttendees());
  }

  
}
