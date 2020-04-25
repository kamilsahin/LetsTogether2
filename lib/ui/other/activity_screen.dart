import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/activity.dart';

class ActivityScreen extends StatefulWidget {
  final Activity activity;
  ActivityScreen(this.activity);
 
  @override
  State<StatefulWidget> createState() => new _ActivityScreenState();
}
 
final activityReference = FirebaseDatabase.instance.reference().child('activity');
 
class _ActivityScreenState extends State<ActivityScreen> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
 
  @override
  void initState() {
    super.initState();
 
    _titleController = new TextEditingController(text: widget.activity.description);
    _descriptionController = new TextEditingController(text: widget.activity.description);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Note')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.activity.key != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.activity.key != null) {
                  activityReference.child(widget.activity.key).set({
                    'title': _titleController.text,
                    'description': _descriptionController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  activityReference.push().set({
                    'title': _titleController.text,
                    'description': _descriptionController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}