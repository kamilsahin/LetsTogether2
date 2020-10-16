import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/view/home/member_profile_attended_activities.dart';
import 'package:letstogether/ui/view/home/member_profile_created_activities.dart';
import 'package:letstogether/ui/view/home/member_profile_main.dart';
import 'package:letstogether/ui/view/home/member_profile_activities.dart';
import 'package:letstogether/ui/view/home/member_profile_comments.dart';

class MemberProileTabbar extends StatefulWidget {
  @override
  _MemberProileTabbarState createState() => _MemberProileTabbarState();

  MemberProileTabbar({this.member, this.activityId});

  final Member member;
  final String activityId;
}

class _MemberProileTabbarState extends State<MemberProileTabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: SafeArea(
            child: TabBar( unselectedLabelColor: Theme.of(context).primaryColorLight ,
                labelColor: Theme.of(context).primaryColorDark , tabs: <Widget>[
              Tab(
                child: Icon(Icons.account_box),
              ),
              Tab(
                child: Icon(Icons.mode_comment),
              ),
              Tab(
                child: Icon(FontAwesomeIcons.child),
              ),
              Tab(
                child: Icon(FontAwesomeIcons.users),
              )
            ]),
          ),
          body: TabBarView(children: <Widget>[
            MemberProfile(member: widget.member,activityId: widget.activityId,),
            MemberProfileComments(memberKey: widget.member.key),
            MemberProfileCreatedActivities(memberKey: widget.member.key),
            MemberProfileAttendedActivities(memberKey: widget.member.key),
          ]),
        ));
  }
}
