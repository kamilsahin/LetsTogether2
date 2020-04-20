import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/ui/other/appbar_page.dart'; 

class MemberProfile extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  const MemberProfile({Key key, this.auth, this.logoutCallback})
      : super(key: key);
  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  final _formKey = new GlobalKey<FormState>();
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  String _memberKey;
  String _memberImage;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  @override
  void initState() {
    _memberKey = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
    _memberImage =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_IMAGE); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showImageUpload(),
            ],
          ),
        ));
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
          :   Container(  
               width: 240.0,
               height: 180.0,
            decoration: BoxDecoration( 
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image : NetworkImage(_memberImage!= null  ? _memberImage : emptyImageUrl),
                )
                ),
          ),
      RaisedButton(
        child: Text('Choose File'),
        onPressed: chooseFile,   
         shape: Theme.of(context).buttonTheme.shape,
                    color : Theme.of(context).buttonColor,
      ),
      RaisedButton(
        child: Text('Upload File'),
        onPressed: () =>uploadFile(),
            shape: Theme.of(context).buttonTheme.shape,
                    color : Theme.of(context).buttonColor, 
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
    storageReference.getDownloadURL().then((fileURL) {
      setState(() async {
        _uploadedFileURL = fileURL;

      _database
            .reference()
            .child("member")
            .child(_memberKey).update({'imageUrl':_uploadedFileURL});

        SharedManager.instance.saveString(SharedKeys.MEMBER_IMAGE , _uploadedFileURL);
      });
    });
  }
}
