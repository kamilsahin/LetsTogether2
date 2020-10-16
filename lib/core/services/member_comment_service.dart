import 'package:firebase_database/firebase_database.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/model/entity/member_comment.dart';

class MemberCommentService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final memberCommentReference =
      FirebaseDatabase.instance.reference().child('memberComment');

  Future getMemberCommentByToMemberId(String memberKey) async {
    List<MemberComment> memberCommentList = new List();
    await memberCommentReference
        .orderByChild("toMemberId")
        .equalTo(memberKey)
        .once()
        .then((DataSnapshot value) async {
      if (value.value != null) {
        var keys = value.value.keys;
        var data = value.value;
        for (var key in keys) {
          var json = new Map<String, dynamic>.from(data[key]);
          MemberComment memberComment = new MemberComment.fromJson(json, key);
          Member fromMember;
          var _todoQuery = _database
              .reference()
              .child("member/${memberComment.fromMemberId}");
          await _todoQuery.once().then((DataSnapshot value) async {
            fromMember = Member.fromSnapshot(value);
            memberComment.fromMember = fromMember;
            memberCommentList.add(memberComment);
          });
        }
      }
    });

    return memberCommentList;
  }

  Future getMemberCommentByFromMemberId(String memberKey) async {
    List<MemberComment> memberCommentList = new List();
    await memberCommentReference
        .orderByChild("fromMemberId")
        .equalTo(memberKey)
        .once()
        .then((DataSnapshot value) async {
      if (value.value != null) {
        var keys = value.value.keys;
        var data = value.value;
        for (var key in keys) {
          var json = new Map<String, dynamic>.from(data[key]);
          MemberComment memberComment = new MemberComment.fromJson(json, key);
          Member toMember;
          var _todoQuery =
              _database.reference().child("member/${memberComment.toMemberId}");
          await _todoQuery.once().then((DataSnapshot value) async {
            toMember = Member.fromSnapshot(value);
            memberComment.toMember = toMember;
            memberCommentList.add(memberComment);
          });
        }
      }
    });

    return memberCommentList;
  }
}
