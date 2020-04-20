import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/activity.dart';


class ActivityDetail extends StatefulWidget {
 
  ActivityDetail({this.activity,this.imageUrl});

  final Activity activity;
  final String imageUrl;
  @override
  State<StatefulWidget> createState() => new _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail>  {
  String _errorMessage;
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();
 var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  @override
  Widget build(BuildContext context) {
    String id = widget.activity.key;
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: <Widget>[
              Hero(
                tag: "activityImage$id}",
                child: Container(
                  child: Image.network(widget.imageUrl !=null ? widget.imageUrl : emptyImageUrl,
                       width: 300, height: 200, fit: BoxFit.scaleDown),
                ),
              ),
              showDateText(id, widget.activity.dateStr),
              showHeaderText(id, widget.activity.header),
              showDescriptionText(id, widget.activity.description),
              Wrap(
                 spacing: 10, 
                 children: <Widget>[
               ],
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton:  _joinActivityButton,
        );
  }
  
  Widget get _joinActivityButton => FloatingActionButton.extended(
         elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)), 
            icon: Icon(Icons.input),
            label: new Text('Join'),
            onPressed: joinSubmit,
      );

  Widget showDateText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.calendar_today),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityDate$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  Widget showHeaderText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.subject),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityHeader$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  Widget showDescriptionText(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.description),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityDescr$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }


   // Perform login or signup
  void joinSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) { 
      try {
        setState(() {
          _isLoading = false;
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
    } else  {
      _isLoading = false;
    }

  }

}
