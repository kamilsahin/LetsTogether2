import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/attendees.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/base/validators.dart';

class AttendeesService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final attendsReference =
      FirebaseDatabase.instance.reference().child('attends');

  Future getActivityListByJoinedMemberId(String memberKey,bool future,bool approved) async {
    List<Attendees> attendeesList = new List();

    int dateTime =
        Validators.instance.convertFromDateToMillisecond(DateTime.now());

    await attendsReference
        .orderByChild("memberId")
        .equalTo(memberKey)
        .once()
        .then((DataSnapshot value) async {
      if (value.value != null) {
        var keys = value.value.keys;
        var data = value.value;
        for (var key in keys) {
          var json = new Map<String, dynamic>.from(data[key]);
          Attendees attendees = new Attendees.fromJson(json, key);
          if(!approved || (approved && attendees.status==3))
          {
            Activity activity;
            var _todoQuery =
                _database.reference().child("activity/${attendees.activityId}");
            await _todoQuery.once().then((DataSnapshot value) async {
              if(value.value!=null){
              activity = Activity.fromSnapshot(value);
              if (activity.dateTime != null && (!future || (future && activity.dateTime > dateTime))) {
                Member createMember;
                await _database
                    .reference()
                    .child("member/${activity.memberId}")
                    .once()
                    .then((DataSnapshot value) async {
                  createMember = Member.fromSnapshot(value);
                  activity.createMember = createMember;
                  attendees.activity = activity;
                  attendeesList.add(attendees);
                });
              }
            }}
            );
          }
        }
      }
    });

    return attendeesList;
  }

  Future getAttendeesByActivityId(String activityKey) async {
    List<Attendees> attendeesList = new List();
    await attendsReference
        .orderByChild("activityId")
        .equalTo(activityKey)
        .once()
        .then((DataSnapshot value) async {
      if (value.value != null) {
        var keys = value.value.keys;
        var data = value.value;
        for (var key in keys) {
          var json = new Map<String, dynamic>.from(data[key]);
          Attendees attendee = new Attendees.fromJson(json, key);
          Member joinMember;
          await _database
              .reference()
              .child("member/${attendee.memberId}")
              .once()
              .then((DataSnapshot value) async {
            joinMember = Member.fromSnapshot(value);
            attendee.member = joinMember;
            attendeesList.add(attendee);
          });
        }
      }
    });
    return attendeesList;
  }
 
}
