import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/services/member_service.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/auth_user.dart';
import 'package:letstogether/ui/base/validators.dart';
import 'package:letstogether/ui/view/base/main_member.dart';
import 'package:provider/provider.dart';

class MemberProfileEdit extends StatefulWidget {
  MemberProfileEdit({this.member});

  final Member member;

  @override
  _MemberProfileEditState createState() => _MemberProfileEditState();
}

class _MemberProfileEditState extends State<MemberProfileEdit> {
  final _formKey = new GlobalKey<FormState>();
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  Member memberEdit;
  String _memberKey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Member curmember;
  MemberService service;

  final memberReference = FirebaseDatabase.instance.reference().child('member');
  final EdgeInsets edgeInsetsconst = EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0);
  TextEditingController _controller;
  String _errorMessage;
  bool _isLoading;

  @override
  void initState() {
    _memberKey = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
    service = MemberService();

    var _todoQuery = _database.reference().child("member/$_memberKey");
    _todoQuery.once().then((value) {
      setState(() {
        curmember = Member.fromSnapshot(value);
      });
    });

    /*_onMemberAddedSubscription =
        memberReference.onChildAdded.listen(_onMemberAdded); 
*/
    memberEdit = widget.member;
    _controller = new TextEditingController(text: widget.member.birthdayStr);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget get _waitingWidget => Center(child: CircularProgressIndicator());

  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (curmember == null) {
      return _waitingWidget;
    }

    String id = curmember.key;
    return Scaffold(
        key: scaffold,
        appBar: AppBarPage(title: "Profilim"),
        body: Stack(
          children: <Widget>[
            _showForm(),
            //  _showCircularProgress(),
          ],
        )
        // drawer: DrawerPage(auth: widget.auth ,logoutCallback : widget.logoutCallback),
        // body: Center(child: SwipeList()));
        //body:  _listActivity(),
        );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(10.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showImageUpload(),
              showNameInput(),
              showSurnameInput(),
              showBirthdayInput(),
              showCityInput(),
              showAboutInput(),
              showHobiesInput(),
              showInstagramInput(),
              showTwitterInput(),
              showFacebookInput(),
              showWebsiteInput(),
              showPrimaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showNameInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.name,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Surname',
            hintText: 'Surname',
            icon: new Icon(
              Icons.account_circle,
            )),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (value) => memberEdit.name = value.trim(),
      ),
    );
  }

  Widget showSurnameInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.surname,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Surname',
            hintText: 'Surname',
            icon: new Icon(
              Icons.account_circle,
            )),
        validator: (value) => value.isEmpty ? 'Surname can\'t be empty' : null,
        onSaved: (value) => memberEdit.surname = value.trim(),
      ),
    );
  }

  Widget showCityInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.city,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'City',
            hintText: 'City',
            icon: new Icon(
              Icons.account_circle,
            )),
        validator: (value) => value.isEmpty ? 'City can\'t be empty' : null,
        onSaved: (value) => memberEdit.city = value.trim(),
      ),
    );
  }

  Widget showBirthdayInput() {
    return new Row(children: <Widget>[
      new Expanded(
          child: new TextFormField(
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: 'Enter your date of birth',
          labelText: 'Birthday',
        ),
        controller: _controller,
        keyboardType: TextInputType.datetime,
        validator: (val) => Validators.instance.isValidBeforeDate(val) ? null : 'Not a valid date',
        onSaved: (val) => memberEdit.birthday = Validators.instance.convertToDate(val),
      )),
      new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: 'Choose date',
        onPressed: (() {
           _chooseDate(context, _controller.text);
        }),
      )
    ]);
  }

  Widget showAboutInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.about,
        maxLines: 5,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'About',
            hintText: 'About',
            icon: new Icon(
              Icons.account_circle,
            )),
        onSaved: (value) => memberEdit.about = value.trim(),
      ),
    );
  }

  Widget showHobiesInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.hobies,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'hobies',
            hintText: 'hobies',
            icon: new Icon(
              Icons.account_circle,
            )),
        validator: (value) => value.isEmpty ? 'hobies can\'t be empty' : null,
        onSaved: (value) => memberEdit.hobies = value.trim(),
      ),
    );
  }

  Widget showInstagramInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.instagram,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'instagram',
            hintText: 'instagram',
            icon: new Icon(
              Icons.account_circle,
            )),
        onSaved: (value) => memberEdit.instagram = value.trim(),
      ),
    );
  }

  Widget showTwitterInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.twitter,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'twitter',
            hintText: 'twitter',
            icon: new Icon(
              Icons.account_circle,
            )),
        onSaved: (value) => memberEdit.twitter = value.trim(),
      ),
    );
  }

  Widget showFacebookInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.facebook,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'facebook',
            hintText: 'facebook',
            icon: new Icon(
              Icons.account_circle,
            )),
        onSaved: (value) => memberEdit.facebook = value.trim(),
      ),
    );
  }

  Widget showWebsiteInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        initialValue: widget.member.website,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'website',
            hintText: 'website',
            icon: new Icon(
              Icons.account_circle,
            )),
        onSaved: (value) => memberEdit.website = value.trim(),
      ),
    );
  }

  File _image;
  String _uploadedFileURL;

  Widget showImageUpload() {
    return new Column(children: <Widget>[
      _image != null
          ? Image.asset(
              _image.path,
              width: 240.0,
              height: 180.0,
            )
          : Container(
              width: 240.0,
              height: 180.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.member.imageUrl != null && widget.member.imageUrl != ""
                    ? widget.member.imageUrl
                    : emptyImageUrl),
              )),
            ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: RaisedButton(
                child: Text('Choose File'),
                onPressed: chooseFile,
                shape: Theme.of(context).buttonTheme.shape,
                color: Theme.of(context).buttonColor,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: RaisedButton(
                child: Text('Upload File'),
                onPressed: () => uploadFile(),
                shape: Theme.of(context).buttonTheme.shape,
                color: Theme.of(context).buttonColor,
              ))
        ],
      )
    ]);
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 300,
    ).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('member/$_memberKey');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });

    if (_uploadedFileURL != null) {
      await _database
          .reference()
          .child("member")
          .child(_memberKey)
          .update({'imageUrl': _uploadedFileURL}).then(
              (value) => scaffold.currentState.showSnackBar(SnackBar(
                    content: Text("Resim Kaydetme islemi basarili "),
                  )));
      memberEdit.imageUrl = _uploadedFileURL;
      //SharedManager.instance.saveString(SharedKeys.MEMBER_IMAGE , _uploadedFileURL);
      Provider.of<AuthUser>(context).setImageUrl(_uploadedFileURL);
      Provider.of<MainMemberDataModal>(context).setMainMember(memberEdit);
    }
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

  Widget showPrimaryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new FloatingActionButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text('Kaydet'),
            // style: Theme.of(context).textTheme.bodyText2),
            //  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        await _database
            .reference()
            .child("member")
            .child(_memberKey)
            .set(memberEdit.toJson())
            .then((value) => _showSuccessAlert());

         Provider.of<MainMemberDataModal>(context).setMainMember(memberEdit);

        /*scaffold.currentState.showSnackBar(SnackBar(
                  content: Text("Kaydetme islemi basarili "),
                )));
*/
        setState(() {
          _isLoading = false;
          //Navigator.pop(context);
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

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
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
  
  Future<void> _showSuccessAlert() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Üyelik bilgileri güncelleme'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Başarıyla kaydedildi'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {
      Navigator.of(context).pop();
    });
  }
}
