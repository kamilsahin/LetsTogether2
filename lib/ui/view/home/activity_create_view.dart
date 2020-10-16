import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/validators.dart';
import 'package:letstogether/core/services/activity/activity_service_creator.dart';
import 'package:letstogether/core/services/activity/activity_service.dart';

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
  Activity newActivity = new Activity();
  final EdgeInsets edgeInsetsconst = EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0);
  TimeOfDay selectedTime;
  String _currentDistrict;
  List distList;
  var cityId;
  ActivityService activityService;
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
        /*  TimeOfDay timeofDay =  Validators.instance.convertToTimeOfDay(newActivity.time);
        final dt = DateTime(newActivity.date.year, newActivity.date.month, newActivity.date.day, timeofDay.hour, timeofDay.minute);
    
        int timeSecond = Validators.instance.convertFromDateToMillisecond(dt);
        print(timeSecond);*/
        userId = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
        newActivity.memberId = userId;
        newActivity.imageUrl = _uploadedFileURL;
        newActivity.city =
            SharedManager.instance.getStringValue(SharedKeys.CITY);
        activityService.setActivityToDB(_newKey, newActivity);

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
    activityService = ActivityServiceCreator.instance;
    distList = new List();
    cityId = SharedManager.instance.getStringValue(SharedKeys.CITY);
    _currentDistrict =
        SharedManager.instance.getStringValue(SharedKeys.DISCTRICT);
    newActivity.disctrict = _currentDistrict;
    _errorMessage = "";
    _isLoading = false;
    activityService.getActivityKey().then((value) {
      setState(() {
        _newKey = value.toString();
      });
    });

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
          title: new Text(
              AppLocalizations.of(context).translate('createNewActivity')),
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
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showImageUpload(),
              showHeaderInput(),
              showDescriptionInput(),
              //showDistrict(),
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
            child: new Text(
                AppLocalizations.of(context).translate('createActivity')),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showHeaderInput() {
    return Padding(
      padding: edgeInsetsconst,
      child: new TextFormField(
        maxLines: 1,
        maxLengthEnforced: true,
        maxLength: 50,
        autofocus: true,
        decoration: new InputDecoration(
            hintText:
                AppLocalizations.of(context).translate('activityHeaderHint'),
            labelText:
                AppLocalizations.of(context).translate('activityHeaderLabel'),
            icon: new Icon(
              Icons.account_circle,
              color: Theme.of(context).iconTheme.color,
            )),
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate('activityHeaderEmptyError')
            : null,
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
        autofocus: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: new InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('activityDescrLabel'),
            hintText:
                AppLocalizations.of(context).translate('activityDescrHint'),
            icon: new Icon(
              Icons.account_circle,
              color: Theme.of(context).iconTheme.color,
            )),
        validator: (value) => value.isEmpty
            ? AppLocalizations.of(context).translate('activityDescrEmptyError')
            : null,
        onSaved: (value) => newActivity.description = value.trim(),
      ),
    );
  }

  void _checkInputHeight() async {
    int count = _textEditingController.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {
      // use a maximum height of 6 rows
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
          hintText: AppLocalizations.of(context).translate('activityDateHint'),
          labelText:
              AppLocalizations.of(context).translate('activityDateLabel'),
        ),
        controller: _dateController,
        keyboardType: TextInputType.datetime,
        validator: (val) => val.isEmpty
            ? AppLocalizations.of(context).translate('activityDateEmptyError')
            : (Validators.instance.isValidAfterDate(val)
                ? null
                : AppLocalizations.of(context).translate('dateNotValid')),
        onSaved: (val) =>
            newActivity.date = Validators.instance.convertToDate(val),
      )),
      new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: AppLocalizations.of(context).translate('chooseDate'),
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
          hintText:
              AppLocalizations.of(context).translate('activityTimeChoose'),
          labelText: 'Time',
        ),
        controller: _timeController,
        keyboardType: TextInputType.number,
        validator: (val) => Validators.instance.isValidTime(val)
            ? null
            : AppLocalizations.of(context).translate('timeNotValid'),
        onSaved: (val) => newActivity.time = val,
      )),
      new IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: AppLocalizations.of(context).translate('chooseTime'),
        onPressed: (() {
          _selectTime(context, _timeController.text);
        }),
      )
    ]);
  }

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate =
        Validators.instance.convertToDate(initialDateString) ?? now;
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
      _dateController.text = Validators.instance.convertFromDate(result);
    });
  }

  Future<void> _selectTime(
      BuildContext context, String initialTimeString) async {
    var initialTime = Validators.instance.convertToTimeOfDay(initialTimeString);
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: initialTime != null ? initialTime : TimeOfDay.now());
    if (picked != null && picked != selectedTime) selectedTime = picked;
    setState(() {
      _timeController.text = Validators.instance.formatTimeOfDay(picked);
    });
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
        child: Text(AppLocalizations.of(context).translate('chooseFile')),
        onPressed: chooseFile,
        shape: Theme.of(context).buttonTheme.shape,
        color: Theme.of(context).buttonColor,
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
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  Widget showDistrict() {
    return StreamBuilder(
      stream: activityService.getActivityListByCity(cityId),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        distList.clear();
        snapshot.data.value.forEach((key, value) {
          distList.add(value);
        });

        return Padding(
            padding: edgeInsetsconst,
            child: DropdownButton<String>(
              hint:
                  new Text(AppLocalizations.of(context).translate('district')),
              value: _currentDistrict,
              onChanged: (String newValue) {
                setState(() {
                  _currentDistrict = newValue;
                  newActivity.disctrict = newValue;
                });
              },
              //  validator: (value) => value == null ? 'field required' : null,
              //   onSaved: (val) => newMember.disctrict = val,
              items: distList.map((e) {
                return new DropdownMenuItem<String>(
                  value: e["id"].toString(),
                  child: new Text(
                    e["name"],
                  ),
                );
              }).toList(),
            ));
      },
    );
  }
}
