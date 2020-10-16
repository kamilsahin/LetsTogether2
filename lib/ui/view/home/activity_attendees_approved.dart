import 'package:flutter/material.dart'; 
import 'package:letstogether/core/model/entity/attendees.dart';  
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/view/home/activity_attendees.dart'; 

class ActivityAttendeesApproved extends ActivityAttendees {
  ActivityAttendeesApproved({this.attendeesList});
 
  final List<Attendees> attendeesList;

  @override
  _ActivityAttendeesApprovedState createState() => _ActivityAttendeesApprovedState();
}

class _ActivityAttendeesApprovedState extends ActivityAttendeesState { 
  @override
  void initState() {
    super.initState();
      if(ActivityAttendeesState.newApprovedList!=null)
    {
      widget.attendeesList.addAll(ActivityAttendeesState.newApprovedList);
      ActivityAttendeesState.newApprovedList.clear();
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
                .translate('activityAttendeesApproved')),
        body: listAttendees());
  }
 
}
