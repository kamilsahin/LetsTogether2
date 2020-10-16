import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/attendees.dart';
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';
import 'package:letstogether/core/services/attendees_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/validators.dart';
import 'package:http/http.dart' as http;

class ActivityDetail extends StatefulWidget {
  ActivityDetail({this.activity, this.imageUrl});

  final Activity activity;
  final String imageUrl;
  @override
  State<StatefulWidget> createState() => new _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  AttendeesService attendeesService;
  String _errorMessage;
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();
  final activityReference =
      FirebaseDatabase.instance.reference().child('activity');
  final attendsReference =
      FirebaseDatabase.instance.reference().child('attends');
  final _textEditingController = TextEditingController();
  bool joinButtonVisible;
  bool showAttendeesList;
  String memberKey;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";
  Attendees attendee;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    attendeesService = AttendeesService();
    joinButtonVisible = true;
    showAttendeesList = false;

    memberKey = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
    if (memberKey == widget.activity.createMember.key) {
      joinButtonVisible = false;
      showAttendeesList = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: activityDetailBuilder,
      /* floatingActionButton: Visibility(
        child: _joinActivityButton,
        visible: joinButtonVisible,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,*/
    );
  }

  Widget get activityDetailBuilder => FutureBuilder(
        future: attendeesService.getAttendeesByActivityId(widget.activity.key),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data is List) {
                  for (Attendees attendees in snapshot.data) {
                    if (attendees.memberId == memberKey) {
                      joinButtonVisible = false;
                      attendee = attendees;
                    } 
                  }
                  return showActivityDetail();
                } else if (snapshot.data is http.Response) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await SharedManager.instance
                        .saveString(SharedKeys.TOKEN, "");
                    Navigator.of(context).pop();
                  });
                }
              }
              return CommonWidgets.instance.notFoundWidget;
            default:
              return CommonWidgets.instance.waitingWidget;
          }
        },
      );

  Widget showActivityDetail() {
    String id = widget.activity.key;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Hero(
            tag: "activityImage$id}",
            child: Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Image.network(
                  (widget != null && widget.imageUrl != null)
                      ? widget.imageUrl
                      : emptyImageUrl,
                  width: 300,
                  height: 200,
                  fit: BoxFit.scaleDown),
            ),
          ),
          CommonWidgets.instance.showDateText(id, widget.activity.dateStr),
          CommonWidgets.instance.showTimeText(id, widget.activity.time),
          CommonWidgets.instance.showHeaderText(id, widget.activity.header),
          CommonWidgets.instance
              .showDescriptionText(id, widget.activity.description),
          Wrap(
            spacing: 10,
            children: <Widget>[],
          ),
          CommonWidgets.instance.showStatusText(context, attendee),
          Visibility(
            child: _joinActivityButton,
            visible: joinButtonVisible,
          ),
        ],
      )),
    );
  }

  Widget get _joinActivityButton => FloatingActionButton.extended(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        icon: Icon(Icons.input),
        label: new Text(AppLocalizations.of(context).translate('joinActivity')),
        onPressed: () {
          showJoinDialog(context);
        },
      );

  bool validateAndSave() {
    return true;
  }

  // Perform login or signup
  void joinSubmit(String joinMessage) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        setState(() {
          _isLoading = false;
        });
        Attendees attendee = new Attendees();
        attendee.message = joinMessage;
        attendee.date = DateTime.now().toLocal();
        attendee.memberId =
            SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
        attendee.time = Validators.instance.formatTimeOfDay(TimeOfDay.now());
        attendee.statusEnum = ActivityAttendStatusEnum.WAITING;
        attendee.activityId = widget.activity.key;

        attendsReference
            .push()
            .set(attendee.toJson())
            .then((value) => print("basarili"));
        setState(() {
          _isLoading = false;
          joinButtonVisible = false;
        });
/*
        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }*/
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      _isLoading = false;
    }
  }

  showJoinDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  maxLines: 5,
                  maxLength: 300,
                  maxLengthEnforced: true,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate('joinActivityMessageLabel'),
                    hintText: AppLocalizations.of(context)
                        .translate('joinActivityMessageHint'),
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text(AppLocalizations.of(context).translate('cancel')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              new FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('joinActivity')),
                  onPressed: () {
                    joinSubmit(_textEditingController.text.toString());
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
 
}
