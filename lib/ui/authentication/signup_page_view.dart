import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:letstogether/core/model/authentication/firebase_user.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/validators.dart';

class SignupPage extends StatefulWidget {
  SignupPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();
  String _errorMessage;
  bool _isLoading;
  Member newMember = new Member();
  FirebaseUser user = new FirebaseUser();
  final EdgeInsets edgeInsetsconst = EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0);
  final MaterialColor textIconColor = Colors.grey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
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
        userId = await widget.auth.signUp(user.email, user.password);
        newMember.userId = userId;
        _database.reference().child("member").push().set(newMember.toJson());
      //  widget.auth.sendEmailVerification();
     //   _showVerifyEmailSentDialog();
        print('Signed up user: $userId');
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        //  _formKey.currentState.reset();
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
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).translate('createNewAccount')),
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

 /* void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showNameInput(),
              showSurnameInput(),
              showGenderSelection(), 
              showBirthDateInput(),
              showPhoneNumberInput(),
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

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(AppLocalizations.of(context).translate('haveAccountSignIn'),
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: () {});
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: edgeInsetsconst,
        child: SizedBox(
          height: 40.0,
          child: new FloatingActionButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)), 
            child: new Text(AppLocalizations.of(context).translate('createAccount')),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero2',
      child: Padding(
        padding: edgeInsetsconst,
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
      padding: edgeInsetsconst,
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: AppLocalizations.of(context).translate('emailHint'),
            labelText: AppLocalizations.of(context).translate('emailLabel'),
            icon: new Icon(
              Icons.mail,
              color: textIconColor,
            )),
        validator: (value) => value.isEmpty ? AppLocalizations.of(context).translate('emailNotEmpty') : null,
        onSaved: (value) => user.email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: AppLocalizations.of(context).translate('passwordLabel'),
            hintText: AppLocalizations.of(context).translate('passwordHint'),
            icon: new Icon(
              Icons.lock,
              color: textIconColor,
            )),
        validator: (value) => value.isEmpty ? AppLocalizations.of(context).translate('passwordNotEmpty') : null,
        onSaved: (value) => user.password = value.trim(),
      ),
    );
  }

  Widget showNameInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: AppLocalizations.of(context).translate('memberNameHint'),
            labelText: AppLocalizations.of(context).translate('memberNameLabel'),
            icon: new Icon(
              Icons.account_circle,
              color: textIconColor,
            )),
        validator: (value) => value.isEmpty ? AppLocalizations.of(context).translate('memberNameNotEmpty') : null,
        onSaved: (value) => newMember.name = value.trim(),
      ),
    );
  }

  Widget showSurnameInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: AppLocalizations.of(context).translate('memberSurnameLabel'),
            hintText: AppLocalizations.of(context).translate('memberSurnameHint'),
            icon: new Icon(
              Icons.account_circle,
              color: textIconColor,
            )),
        validator: (value) => value.isEmpty ? AppLocalizations.of(context).translate('memberSurnameNotEmpty') : null,
        onSaved: (value) => newMember.surname = value.trim(),
      ),
    );
  }
 
  Widget showGenderSelection() {
    return new Row(
      children: <Widget>[ 
        Text(AppLocalizations.of(context).translate('gender')),
        addRadioButton(0, AppLocalizations.of(context).translate('male')),
        addRadioButton(1, AppLocalizations.of(context).translate('female'))
      ],
    );
  }


  String gender;

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: btnValue.toString(),
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              newMember.gender = btnValue;
              gender = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Widget showPhoneNumberInput() {
    return new TextFormField(
      decoration: new InputDecoration(
        icon: const Icon(Icons.phone),
        hintText: AppLocalizations.of(context).translate('memberPhoneNumHint'),
        labelText: AppLocalizations.of(context).translate('memberPhoneNumLabel'), 
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        new WhitelistingTextInputFormatter(new RegExp(r'^[()\d -]{1,15}$')),
      ],
      validator: (value) => Validators.instance.isValidPhoneNumber(value)
          ? null
          : AppLocalizations.of(context).translate('memberPhoneNumNotValid'),
      onSaved: (val) => newMember.phoneNumber = val,
    );
  }

  Widget showBirthDateInput() {
    return new Row(children: <Widget>[
      new Expanded(
          child: new TextFormField(
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: AppLocalizations.of(context).translate('memberBirthdayHint'),
          labelText: AppLocalizations.of(context).translate('memberBirthdayLabel'),
        ),
        controller: _controller,
        keyboardType: TextInputType.datetime,
        validator: (val) => Validators.instance.isValidBeforeDate(val) ? null : AppLocalizations.of(context).translate('dateNotValid'),
        onSaved: (val) => newMember.birthday = Validators.instance.convertToDate(val),
      )),
      new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip:  AppLocalizations.of(context).translate('chooseDate'),
        onPressed: (() {
          _chooseDate(context, _controller.text);
        }),
      )
    ]);
  }

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = Validators.instance.convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = Validators.instance.convertFromDate(result);
    });
  }
  
 
}
