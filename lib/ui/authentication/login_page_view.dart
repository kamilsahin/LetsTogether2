import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/authentication/signup_page_view.dart';
import 'package:letstogether/ui/base/auth_user.dart';
import 'package:letstogether/ui/view/base/main_member.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _errorMessage;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  bool _isLoading;
  Member member;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        var query = _database
            .reference()
            .child("member")
            .orderByChild("userId")
            .equalTo(userId);
        
        var snapshot = await query.once();
        var keys = snapshot.value.keys;
        var data = snapshot.value;

        for (var key in keys) {
          var json = new Map<String, dynamic>.from(data[key]);
          member = new Member().fromJson(json, key); 
           Provider.of<AuthUser>(context).setImageUrl( member.imageUrl);
          SharedManager.instance.saveString(SharedKeys.MEMBERID , member.key);
          SharedManager.instance.saveString(SharedKeys.MEMBER_NAMESURNAME , member.name +" "+member.surname);
          SharedManager.instance.saveString(SharedKeys.MEMBER_IMAGE , member.imageUrl);
          Provider.of<MainMemberDataModal>(context).setMainMember(member);
        /*   scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Welcome ${member.name} ${member.surname}",)));*/
        }

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        } 
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key : scaffoldKey,
        appBar: new AppBar(
          title: new Text('Lets Together'),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
            )),
        //  validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => value.isEmpty
            ? _email = "kamilsahin@gmail.com"
            : _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
            )),
        // validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) =>
            value.isEmpty ? _password = "123456" : _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text('Create account'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignupPage(
                    auth: widget.auth,
                  )));
        });
  }
/*
  Widget showSecondaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new FloatingActionButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text('Create account'),
           // style: Theme.of(context).textTheme.bodyText2),
           //  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
               Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SignupPage( auth: widget.auth, )));
            }),
          ),
        );
  }
*/

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new FloatingActionButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text('Login'),
            // style: Theme.of(context).textTheme.bodyText2),
            //  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
