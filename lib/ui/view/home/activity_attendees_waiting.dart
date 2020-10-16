import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/attendees.dart';
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';
import 'package:letstogether/core/services/activity/activity_service_real.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/view/home/activity_attendees.dart';

class ActivityAttendeesWaiting extends ActivityAttendees {
  ActivityAttendeesWaiting({this.attendeesList});

  final List<Attendees> attendeesList;

  @override
  _ActivityAttendeesWaitingState createState() =>
      _ActivityAttendeesWaitingState();
}

class _ActivityAttendeesWaitingState extends ActivityAttendeesState {
  final attendsReference =
      FirebaseDatabase.instance.reference().child('attends');

  // final CollectionReference attendeesCollection =
  //     Firestore.instance.collection("attends");
  String _errorMessage;
  bool _isLoading;
  ActivityService service;
  final _textEditingController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isLoading = false;
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
                .translate('activityAttendeesWaiting')),
        body: _isLoading ? Center(child: CircularProgressIndicator())  : listAttendees());
  }
  
  @override
  Widget attendeeCard(Attendees attendee, int index) {
      return Dismissible(
        key: Key(attendee.key),
        background: slideRightBackground(),
        secondaryBackground: slideLeftBackground(),
       confirmDismiss: (DismissDirection dismissDirection) async {
            switch(dismissDirection) {
              case DismissDirection.startToEnd:  
                return await _showAcceptDialog(context, attendee, index) == true;
              case DismissDirection.endToStart: 
                return await _showRejectDialog(context, attendee, index)  == true;
              case DismissDirection.horizontal:
              case DismissDirection.vertical:
              case DismissDirection.up:
              case DismissDirection.down:
                assert(false);
            }
            return false;
          },
         onDismissed: (direction){
           print(direction);
          _setAttendeeStatus(direction, attendee, index);
          setState(() {
           // widget.attendeesList.removeAt(index);
          });
        },
        child: attendCard(attendee),
      );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.thumb_down,
              color: Colors.white,
            ),
            Text(
              " Red",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.thumb_up,
              color: Colors.white,
            ),
            Text(
              " Kabul",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  void _setAttendeeStatus(
    DismissDirection direction, Attendees attendee, int index) {
    _isLoading = true;
   print(index);
    if (direction == DismissDirection.startToEnd) {
      attendee.statusEnum = ActivityAttendStatusEnum.APPROVED;

    } else if (direction == DismissDirection.endToStart) {
      attendee.statusEnum = ActivityAttendStatusEnum.REJECTED;
    } 
    if(_textEditingController.text!=null) {
      print(_textEditingController.text.toString());
      attendee.responseMessage = _textEditingController.text.toString();
    }

    attendsReference
        .child(attendee.key)
        .set(attendee.toJson())
        .then((value) => setState(() {
              Attendees rmvAttend = widget.attendeesList.removeAt(index); 
              if (direction == DismissDirection.startToEnd) {
                ActivityAttendeesState.newApprovedList.add(rmvAttend);
              } else if (direction == DismissDirection.endToStart) {
                ActivityAttendeesState.newRejectedList.add(rmvAttend);
              }
              _isLoading = false;
            })); 
  }

  Future<bool> _showAcceptDialog(BuildContext context, Attendees attendee, int index) async {
    _textEditingController.clear();
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  maxLines: 5,
                  maxLength: 150,
                  maxLengthEnforced: true,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate('attendeeAcceptMessageLabel'),
                    hintText: AppLocalizations.of(context)
                        .translate('attendeeAcceptMessageHint'),
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text(AppLocalizations.of(context).translate('cancel')),
                  onPressed: () {
                     Navigator.of(context).pop(false);
                  }),
              new FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('attendeeAcceptButtonMessage')),
                  onPressed: () {
              //      joinSubmit(attendee, index, true, _textEditingController.text.toString());
                     Navigator.of(context).pop(true);
                  })
            ],
          );
        }
        );
  }

 Future<bool> _showRejectDialog(BuildContext context, Attendees attendee, int index) async {
    _textEditingController.clear();
     return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  maxLines: 5, 
                  maxLength: 150,
                  maxLengthEnforced: true,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate('attendeeRejectMessageLabel'),
                    hintText: AppLocalizations.of(context)
                        .translate('attendeeRejectMessageHint'),
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text(AppLocalizations.of(context).translate('cancel')),
                  onPressed: () {
                  Navigator.of(context).pop(false);
                  }),
              new FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('attendeeRejectButtonMessage')),
                  onPressed: () {
                 //   joinSubmit(attendee, index, false, _textEditingController.text.toString());
                   Navigator.of(context).pop(true);
                  })
            ],
          );
        });
  }

 
}
