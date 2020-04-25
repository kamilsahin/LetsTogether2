import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/view/home/member_profile_main.dart';
import 'package:letstogether/ui/view/home/member_profile_activities.dart';
import 'package:letstogether/ui/view/home/member_profile_comments.dart';

class MemberProileTabbar extends StatefulWidget {
  @override
  _MemberProileTabbarState createState() => _MemberProileTabbarState();

  MemberProileTabbar({this.member});

  final Member member;
}

class _MemberProileTabbarState extends State<MemberProileTabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                child: Icon(Icons.power_input),
              )
            ]),
          ),
          body: TabBarView(children: <Widget>[
            MemberProfile(member: widget.member),
            MemberProfileComments(memberKey: widget.member.key),
            MemberProfileActivities(memberKey: widget.member.key),
          ]),
        ));
  }
}
