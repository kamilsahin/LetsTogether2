import 'package:flutter/material.dart';
import 'package:letstogether/ui/other/member_list_view.dart';
import 'package:letstogether/ui/view/home/activity_list_view.dart';

class TabbarView extends StatefulWidget {
  @override
  _TabbarViewState createState() => _TabbarViewState();
}

class _TabbarViewState extends State<TabbarView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController (
      length: 2,
       child : Scaffold(
          bottomNavigationBar: SafeArea(
            child: TabBar(
               labelColor: Colors.blue,
                tabs: <Widget> [
                  Tab(child: Icon(Icons.access_time),),
                  Tab(child: Icon(Icons.account_box),)
                ]
            ),
         ),
         body: TabBarView(
           children: <Widget>[
             ActivityListView(),
             MemberList()
           ]
         ),
       )
    );
  }
}
