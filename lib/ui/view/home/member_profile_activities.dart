import 'package:flutter/material.dart';
import 'package:letstogether/ui/base/appbar_page.dart';

class MemberProfileActivities extends StatefulWidget {

  MemberProfileActivities({this.memberKey});

  final String memberKey;

  @override
  _MemberProfileActivitiesState createState() => _MemberProfileActivitiesState();
}

class _MemberProfileActivitiesState extends State<MemberProfileActivities> {
  @override
  Widget build(BuildContext context) {
    String id = widget.memberKey;
    return Scaffold(
        appBar: AppBarPage(title: "Üye Aktiviteleri"),
    );
  }
}