import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/main_member.dart';
import 'package:letstogether/ui/base/validators.dart';
import 'package:letstogether/ui/view/home/member_profile_edit.dart';
import 'package:provider/provider.dart';

class MemberProfile extends StatefulWidget {
  MemberProfile({this.member});

  final Member member;

  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  final _formKey = new GlobalKey<FormState>();
  var emptyImageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  String _memberKey; 
  bool ownProfile = false;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Member member;
  
  @override
  void initState() {
    _memberKey = SharedManager.instance.getStringValue(SharedKeys.MEMBERID);
    if(widget.member.key == _memberKey)
    {
      ownProfile = true;
    }

   /* _memberImage =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_IMAGE);*/
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ownProfile) 
    { 
      member = Provider.of<MainMemberDataModal>(context).getMainMember;
    } else {
      member = widget.member;
    }

    return Scaffold(
        appBar: AppBarPage(title: AppLocalizations.of(context).translate('memberProfile')),
        body: Stack(
          children: <Widget>[
            _showForm(),
          ],
        ));
  }

  Widget _showForm() {
    String id = member.key;
    return new Container(
        padding: EdgeInsets.all(10.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showImageUpload(id),
              showNameSurname(
                  id, member.name + " " + member.surname),
              showBirthday(id, member.birthday),
              showGender(id, member.gender),
              showCity(id, member.city),
              showAbout(id, member.about),
              showHobies(id, member.hobies),
              showInstagram(id, member.instagram),
              showTwitter(id, member.twitter),
              showFacebook(id, member.facebook),
              showWebsite(id, member.website),
              showEditButton(),
            ],
          ),
        ));
  }

  Widget showNameSurname(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
        leading: const Icon(Icons.perm_identity),
        //title: const Text('Header'),
        title: Hero(
          tag: "activityCMemName$id",
          child: Container(child: Text(value)),
        ),
      ),
    );
  }

  Widget showBirthday(String id, DateTime valueDate) {
    String value = Validators.instance.convertFromDate(valueDate);
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.birthdayCake),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showGender(String id, int value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.genderless),
          title: Container(child: Text(value == 0 ? AppLocalizations.of(context).translate('female') : AppLocalizations.of(context).translate('male')))),
    );
  }

  Widget showCity(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.city),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showAbout(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(Icons.description),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showHobies(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.campground),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showInstagram(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.instagram),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showTwitter(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.twitter),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showFacebook(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.facebook),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showWebsite(String id, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new ListTile(
          leading: const Icon(FontAwesomeIcons.weebly),
          title: Container(child: Text(value != null ? value : ""))),
    );
  }

  Widget showImageUpload(String id) {
    return new Column(children: <Widget>[
     Hero(
      tag: "activityMemberImage$id}",
      child: Container(
        width: 240.0,
        height: 180.0,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(member.imageUrl != null && member.imageUrl != ""
              ? member.imageUrl
              : emptyImageUrl),
        )),
      ),
     )
    ]);
  }

  Widget showEditButton() {
    return new Visibility(
        visible: ownProfile,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
            child: SizedBox(
              height: 40.0,
              child: new FloatingActionButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: new Text(AppLocalizations.of(context).translate('editProfile') ),
                // style: Theme.of(context).textTheme.bodyText2),
                //  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MemberProfileEdit(
                      member: member,
                    );
                  })).then((value) {
                    setState(() {
 
                    });
                  })
                },
              ),
            )));
  }
}
