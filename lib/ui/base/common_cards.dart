import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/core/model/entity/member_comment.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/view/home/activity_attendess_tabbar.dart';
import 'package:letstogether/ui/view/home/activity_detail.dart';
import 'package:letstogether/ui/view/home/activity_messages.dart';
import 'package:letstogether/ui/view/home/member_profile_tabbar.dart';

class CommonCards {

  static CommonCards instance = CommonCards._privateConstructor();
 
  CommonCards._privateConstructor();


 Widget activityCard(Activity activity, context,bool createdActivity) { 
    return  Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 5,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            height: 222.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MemberProileTabbar(
                          member: activity.createMember,
                          activityId: activity.key,
                        );
                      }))
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 50, 
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                     CommonWidgets.instance.showActivityMemberImage(context, activity),
                                  ]),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.49,
                          height: 50,
                          alignment: Alignment.centerLeft, 
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[ new Expanded(
                                    flex: 1,
                                    child: new  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child : CommonWidgets.instance.showActivityMemberNameSurname(context, activity)
                                 ))
                                 ,
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                        visible: createdActivity,  
                        child: Container(
                        width: MediaQuery.of(context).size.width * 0.27,
                          height: 50, 
                          alignment: Alignment.centerRight, 
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center ( child : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                showMessagesButton(context,activity),
                                showAttendeesButton(context,activity),
                              ],
                            ),
                            ),
                          ),
                        )
                        )
                      ],
                    ),
                  ),
                ),
                // Activity
                GestureDetector(
                    onTap: () => {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ActivityDetail(
                              activity: activity,
                              imageUrl: activity.imageUrl,
                            );
                          }))
                        },
                    child: Container(
                      //  color: Theme.of(context).primaryColorLight,
                      height: 170,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: CommonWidgets.instance.showActivityHeader(context,activity),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                                  new Expanded(
                                    flex: 1,
                                    child: new SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child:  CommonWidgets.instance.showActivityDescr(context,activity),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                       CommonWidgets.instance.showActivityImage(context,activity),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 3),
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.teal),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child:  CommonWidgets.instance.showActivityDate(context,activity),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 3, 0, 3),
                                        child: Container(
                                          width: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.red),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child:  CommonWidgets.instance.showActivityTime(context,activity),
                                        ),
                                      )
                                    ]),
                              )),
                        ],
                      ),
                    ))
              ],
            )),
      );
  }
 

  Widget memberCommentCard(MemberComment memberComment,context) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      elevation: 5,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 200.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 198,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)), ),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MemberProileTabbar(
                        member: memberComment.fromMember,
                      );
                    }))
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 180,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CommonWidgets.instance.showMemberImage(context,memberComment.fromMember),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 150,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.teal),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      child: CommonWidgets.instance.showMemberNameSurname(context,memberComment.fromMember),
                                    ),
                                  ),
                                ]),
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(children: <Widget>[
                            Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 25,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      flex: 1,
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          child: CommonWidgets.instance.showPoint(context, memberComment.point!=null ?  memberComment.point.toString() : ""),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                            Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 150,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      flex: 1,
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          child: CommonWidgets.instance.showComment(context, memberComment.comment!=null ?  memberComment.comment : ""),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                           
                          ],
                          ) 
                       ),
                   
                    ],
                  ),
                ),
              ),
              // Activity
            ],
          )),
    );
  }

  

   Widget showAttendeesButton(context, activity) {
    return new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip:  AppLocalizations.of(context).translate('showAttendeesList'),
        onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                      /*  return ActivityAttendeesTabbar(
                          activity: activity,
                        );*/
                        return ActivityAttendeesTabbar(
                          activity: activity,
                        ); 
                      }));
       }
       ),
      );
  }

  Widget showMessagesButton(context, activity) {
    return new IconButton(
        icon: new Icon(Icons.message),
        tooltip:  AppLocalizations.of(context).translate('activityMessages'),
        onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                      /*  return ActivityAttendeesTabbar(
                          activity: activity,
                        );*/
                        return ActivityMessages(
                          activity: activity,
                        ); 
                      }));
       }
       ),
      );
  }
  
}