import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/member.dart'; 
import 'package:letstogether/core/model/entity/member_comment.dart'; 
import 'package:letstogether/core/services/member_comment_service.dart';
import 'package:letstogether/core/services/member_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/common_cards.dart';
import 'package:letstogether/ui/base/common_widgets.dart';
import 'package:letstogether/ui/base/multi_select_chip.dart';
import 'package:letstogether/ui/base/validators.dart';
import 'package:http/http.dart' as http; 

class MemberProfileComments extends StatefulWidget {
  MemberProfileComments({this.memberKey});

  final String memberKey;

  @override
  _MemberProfileCommentsState createState() => _MemberProfileCommentsState();
}

class _MemberProfileCommentsState extends State<MemberProfileComments> {
  MemberCommentService service;
  MemberService memberService;

  List<MemberComment> memberCommentsList;
    String _errorMessage;
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();
  bool addCommentButtonVisible;
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  final memberCommentReference =
      FirebaseDatabase.instance.reference().child('memberComment');
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();
  bool isSelected2;
  int selectedChoice = 0; 
  List<int> reportList = [1,2,3,4,5];
  @override
  void initState() {
    super.initState();
    addCommentButtonVisible = true;
   String memberKey = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
   if(memberKey == widget.memberKey)
   {
     addCommentButtonVisible = false; 
   }

    service = MemberCommentService();
    memberService = MemberService();
    isSelected2 = false; 
    memberCommentsList = new List();
    var _todoQuery = _database.reference().child("activity");
    _todoQuery.once();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBarPage(
            title: AppLocalizations.of(context).translate('memberComments')),
       body: activityCommentsBuilder,
       floatingActionButton: _fabButton ,
       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked
    );
  }

  Widget get activityCommentsBuilder => FutureBuilder(
        future: service.getMemberCommentByToMemberId(widget.memberKey),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data is List) {
                 return _listMemberComments(snapshot.data);
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
   
  Widget _listMemberComments(List<dynamic> list) {
    memberCommentsList = list;
    list.sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) =>
            CommonCards.instance.memberCommentCard(list[index],context));
  }
  
  Widget get _fabButton => Visibility(
      visible: addCommentButtonVisible,
      child: FloatingActionButton(
        onPressed: () {
          showAddTodoDialog(context);
        },
        child: Icon(Icons.add),
      )
    );

  showAddTodoDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Column(
              children: <Widget>[
               MultiSelectChip(reportList : reportList,
                 onSelectionChanged : (selectedPoint) {
                setState(() {
                  selectedChoice = selectedPoint;
                });}),
                new Expanded(
                  child: new TextField(
                  controller: _textEditingController,
                  maxLines: 5,
                  autofocus: true,
                  maxLength: 300,
                  maxLengthEnforced: true,
                  decoration: new InputDecoration(
                    labelText:
                        AppLocalizations.of(context).translate('yourComment'),
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text(AppLocalizations.of(context).translate('cancel')),
                  highlightColor: Colors.red,
                  padding:  const EdgeInsets.all(5.0),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: Text(AppLocalizations.of(context).translate('save')),
                    padding:  const EdgeInsets.all(10.0),
                  onPressed: () {
                    insertComment(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
  
  // Perform login or signup
  void insertComment(String comment) async { 
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
     try {
        setState(() {
          _isLoading = false;
        });
        MemberComment memberComment = new MemberComment();
        memberComment.comment = comment;
        memberComment.date = DateTime.now().toLocal();
        memberComment.fromMemberId =
            SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
        memberComment.toMemberId = widget.memberKey;
        memberComment.time = Validators.instance.formatTimeOfDay(TimeOfDay.now());
        memberComment.point = selectedChoice; 
        
        int pointSum = selectedChoice;
        for (var item in memberCommentsList) {
          pointSum+=item.point;
        } 
  
        memberCommentReference
            .push().set(memberComment.toJson())
            .then((value) => print("basarili"));
        setState(() {
          _isLoading = false;
          addCommentButtonVisible = false;
        
          _database.reference().child("member/${memberComment.toMemberId}").once().
          then((DataSnapshot value){
            setState(() {
               Member memberEdit = Member.fromSnapshot(value);
                 memberEdit.avgPoint = (pointSum/(memberCommentsList.length+1));
                 print(memberEdit.avgPoint);
              _database
            .reference()
            .child("member")
            .child(memberComment.toMemberId)
            .set(memberEdit.toJson());
            });

        });
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
  }

}
