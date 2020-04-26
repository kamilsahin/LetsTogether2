import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/services/activity_service.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';

class MemberProfileComments extends StatefulWidget {

  MemberProfileComments({this.memberKey});

  final String memberKey;

  @override
  _MemberProfileCommentsState createState() => _MemberProfileCommentsState();
}

class _MemberProfileCommentsState extends State<MemberProfileComments> {
  ActivityService service;
  List<Member> activityList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = ActivityService();

    activityList = new List();
    var _todoQuery = _database.reference().child("activity");
    _todoQuery.once();
  }

  @override
  void dispose() { 
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String id = widget.memberKey;
    return Scaffold(
        appBar: AppBarPage(title: AppLocalizations.of(context).translate('memberComments')),
         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _fabButton
    );
  }

  Widget get _fabButton => 
  Visibility (visible: true,
  child : FloatingActionButton(
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
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                  controller: _textEditingController,
                  maxLines: 5,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context).translate('yourComment'),
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  addNewTodo(String todoItem) {
    /*
    if (todoItem.length > 0) {
      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }*/
  }
  
}