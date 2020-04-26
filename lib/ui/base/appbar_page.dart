import 'package:flutter/material.dart';
import 'package:letstogether/core/model/base/base_auth.dart';

class AppBarPage extends StatefulWidget implements PreferredSizeWidget  {
  final String title;  
   final Widget child;  
   final Function onPressed;  
   final Function onTitleTapped;  
 final BaseAuth auth;
  final VoidCallback logoutCallback;
 
  @override
  _AppBarPageState createState() => _AppBarPageState();
 
  AppBarPage({this.title, this.child, this.onPressed, this.onTitleTapped, this.auth, this.logoutCallback}) ;

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}


class _AppBarPageState extends State<AppBarPage> {
  
  
  @override
  AppBar build(BuildContext context) {
    return new AppBar(  
      title: new Text(widget.title),
       /*   actions: <Widget>[
             new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut),
             PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ), 
          ],*/
        );
  }
/*
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }*/
}