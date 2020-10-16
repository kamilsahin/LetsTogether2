import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letstogether/core/model/entity/attendees.dart';
import 'package:letstogether/core/model/enums/activity_attend_status_enum.dart';
import 'package:letstogether/ui/base/app_localizations.dart';

class CommonWidgets {
  static CommonWidgets instance = CommonWidgets._privateConstructor();
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  CommonWidgets._privateConstructor();

  Widget get notFoundWidget => Center(
        child: Text("Not Found"),
      );

  Widget get waitingWidget => Center(child: CircularProgressIndicator());

  Widget showMemberImage(context, member) {
    return Hero(
      tag: "memberImage${member.key}}",
      transitionOnUserGestures: false,
      child: Container(
        width: 120.0,
        height: 90.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(member != null && member.imageUrl != null
                    ? member.imageUrl
                    : emptyImageUrl))),
      ),
    );
  }

  Widget showActivityMemberImage(context, activity) {
    return Hero(
      tag: "activityMemberImage${activity.key}}",
      transitionOnUserGestures: false,
      child: Container(
        width: 60.0,
        height: 45.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(activity.createMember.imageUrl != null
                    ? activity.createMember.imageUrl
                    : emptyImageUrl))),
      ),
    );
  }

  Widget showMemberNameSurname(context, member) {
    return Hero(
      tag: "activityCMemName${member.key}",
      child: Text(
          member != null
              ? member.name + " " + member.surname
              : AppLocalizations.of(context).translate('nameSurname'),
          style: Theme.of(context).textTheme.subtitle1),
    );
  }

  Widget showActivityMemberNameSurname(context, activity) {
    return Hero(
        tag: "activityCMemName${activity.key}",
        child: FittedBox(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          child: Text(
              activity.createMember != null
                  ? activity.createMember.name +
                      " " +
                      activity.createMember.surname
                  : AppLocalizations.of(context).translate('nameSurname'),
              style: Theme.of(context).textTheme.subtitle1),
        ));
  }

  Widget showComment(context, message) {
    return Text(message, maxLines: null);
  }

  Widget showPoint(context, message) {
    return Text("Verdiği Puan : " + message,
        style: Theme.of(context).textTheme.headline6);
  }

  Widget showAttendeeMessage(context, message) {
    return Text(message, maxLines: null);
  }

  Widget showAttendeeResponseMessage(context, message) {
    return Text(message, maxLines: null);
  }

  Widget showDateText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(FontAwesomeIcons.calendar),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityDate$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  Widget showTimeText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.timer),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityTime$id",
          child: Container(child: Text(value != null ? value : "")),
        ),
      ),
    );
  }

  Widget showHeaderText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.subject),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityHeader$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  Widget showDescriptionText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.description),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityDescr$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  Widget showActivityHeader(context, activity) {
    return Hero(
      tag: "activityHeader${activity.key}",
      child: Text(activity.header,
          maxLines: 2, style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget showActivityDescr(context, activity) {
    return Hero(
      tag: "activityDescr${activity.key}",
      child: Text(
        activity.description,
        maxLines: null,
        style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 48, 48, 54)),
      ),
    );
  }

  Widget showActivityImage(context, activity) {
    return Hero(
      tag: "activityImage${activity.key}",
      transitionOnUserGestures: false,
      child: Container(
        width: 120.0,
        height: 90.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5), topLeft: Radius.circular(5)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(activity.imageUrl != null
                    ? activity.imageUrl
                    : emptyImageUrl))),
      ),
    );
  }

  Widget showActivityDate(context, activity) {
    return Hero(
      tag: "activityDate${activity.key}",
      transitionOnUserGestures: false,
      child: Text(activity.dateStr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1),
    );
  }

  Widget showActivityTime(context, activity) {
    return Hero(
      tag: "activityTime${activity.key}",
      transitionOnUserGestures: false,
      child: Text(activity.time != null ? activity.time : "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1),
    );
  }

  Widget showStatusText(context, Attendees attendee) {
    ActivityAttendStatusEnum statusEnum;
    if (attendee != null) {
      statusEnum = attendee.statusEnum;
    }

    return Visibility(
        visible: attendee != null,
        child: Container(
          alignment: Alignment.bottomCenter,
          color: getStatusColor(context, statusEnum),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                attendee!=null ? attendee.enumToString() : "" ,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        )
      );
  }

  Color getStatusColor(context, ActivityAttendStatusEnum statusEnum) {
    switch (statusEnum) {
      case ActivityAttendStatusEnum.WAITING:
        return Theme.of(context).primaryColorLight;
      case ActivityAttendStatusEnum.APPROVED:
        return Theme.of(context).primaryColor;
      case ActivityAttendStatusEnum.REJECTED:
        return Theme.of(context).primaryColorDark;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
