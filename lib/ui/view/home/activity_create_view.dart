import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:intl/intl.dart';

class ActivityCreate extends StatefulWidget {
  ActivityCreate({this.auth});
  final BaseAuth auth;
  @override
  _ActivityCreateState createState() => _ActivityCreateState();
}

class _ActivityCreateState extends State<ActivityCreate> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();
  String _errorMessage;
  bool _isLoading;
  String _newKey;
  DatabaseReference databaseRef;
  Activity newActivity = new Activity();
  final EdgeInsets edgeInsetsconst = EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0);
  final MaterialColor textIconColor = Colors.grey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  TimeOfDay selectedTime;
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
        userId = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
        newActivity.memberId = userId;
        newActivity.imageUrl = _uploadedFileURL;
        databaseRef.child('activity').child(_newKey).set(newActivity.toJson());
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
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
     super.initState();
    _errorMessage = "";
    _isLoading = false;
    databaseRef = _database.reference();
    _newKey = databaseRef.child('activity').push().key;
    _textEditingController.addListener(_checkInputHeight);
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Yeni Aktivite Oluştur'),
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

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showImageUpload(),
              //  showLogo(),
              showHeaderInput(),
              showDescriptionInput(),
              showActivityDateInput(),
              showActivityTimeInput(),
              showPrimaryButton(),
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

  Widget showPrimaryButton() {
    return new Padding(
        padding: edgeInsetsconst,
        child: SizedBox(
          height: 40.0,
          child: new FloatingActionButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text('Create activity'),
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

  Widget showHeaderInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        maxLines: 1,
        maxLengthEnforced: true,
        maxLength: 50,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Header',
            labelText: 'Header',
            icon: new Icon(
              Icons.account_circle,
              color: textIconColor,
            )),
        validator: (value) => value.isEmpty ? 'Header can\'t be empty' : null,
        onSaved: (value) => newActivity.header = value.trim(),
      ),
    );
  }

  double _inputHeight = 50;
    final TextEditingController _textEditingController = TextEditingController();

  Widget showDescriptionInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        controller: _textEditingController,
        maxLines: 4,
        maxLengthEnforced: true,
        maxLength: 300,
        autofocus: false,
        keyboardType: TextInputType.multiline, 
        textInputAction: TextInputAction.newline,
        decoration: new InputDecoration(
            labelText: 'Description',
            hintText: 'Description',
            icon: new Icon(
              Icons.account_circle,
              color: textIconColor,
            )),
        validator: (value) =>
            value.isEmpty ? 'Description can\'t be empty' : null,
        onSaved: (value) => newActivity.description = value.trim(),
      ),
    );
  }
 

  void _checkInputHeight() async {
    int count = _textEditingController.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {  // use a maximum height of 6 rows 
    // height values can be adapted based on the font size
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  Widget showActivityDateInput() {
    return new Row(children: <Widget>[
      new Expanded(
          child: new TextFormField(
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: 'Enter your activity date',
          labelText: 'Date',
        ),
        controller: _dateController,
        keyboardType: TextInputType.datetime,
        validator: (val) => isValidDob(val) ? null : 'Not a valid date',
        onSaved: (val) => newActivity.date = convertToDate(val),
      )),
      new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: 'Choose date',
        onPressed: (() {
          _chooseDate(context, _dateController.text);
        }),
      )
    ]);
  }

  Widget showActivityTimeInput() {
    return new Row(children: <Widget>[
      new Expanded(
          child: new TextFormField(
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: 'Enter your activity time',
          labelText: 'Time',
        ),
        controller: _timeController,
        keyboardType: TextInputType.number,
        validator: (val) => isValidTime(val) ? null : 'Not a valid time',
        onSaved: (val) => newActivity.time = val,
      )),
      new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: 'Choose time',
        onPressed: (() {
          _selectTime(context, _timeController.text);
        }),
      )
    ]);
  }

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
/*    initialDate = (initialDate.isAfter(now)
        ? initialDate
        : now);
*/
    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: now,
        lastDate: new DateTime(DateTime.now().year + 1));

    if (result == null) return;

    setState(() {
      _dateController.text = new DateFormat('dd-MM-yyyy').format(result);
    });
  }

  Future<void> _selectTime(
      BuildContext context, String initialTimeString) async {
    var initialTime = convertToTimeOfDay(initialTimeString);
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: initialTime != null ? initialTime : TimeOfDay.now());
    if (picked != null && picked != selectedTime) selectedTime = picked;
    setState(() {
      _timeController.text = formatTimeOfDay(picked);
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isAfter(new DateTime.now());
  }

  bool isValidTime(String time) {
    if (time.isEmpty) return false;

    return true;
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat('dd-MM-yyyy').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  TimeOfDay convertToTimeOfDay(String input) {
    if (input == null || input.isEmpty) return null;
    try {
      final format = DateFormat.jm(); //"6:00 AM"
      return TimeOfDay.fromDateTime(format.parse(input));
    } catch (e) {
      return null;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  File _image;
  String _uploadedFileURL;
  Widget showImageUpload() {
    return new Column(children: <Widget>[
      _image != null
          ? Image.asset(
              _image.path,
              height: 150,
            )
          : Container(height: 150),
      RaisedButton(
        child: Text('Choose File'),
        onPressed: chooseFile,
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
        /*  img.Image imageDec = img.decodeImage(image.readAsBytesSync());
        // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
        img.Image resizedImage = img.copyResize(imageDec, width: 120);
        File resizedFile = File('resized_img.jpg')
          ..writeAsBytesSync(img.encodeJpg(resizedImage));
        _image = resizedFile;*/
        _image = image;
        uploadFile();
      });
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('activity/$_newKey');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}
