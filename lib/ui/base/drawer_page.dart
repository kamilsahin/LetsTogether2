import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/auth_user.dart';  
import 'package:letstogether/ui/view/home/member_profile_tabbar.dart';
import 'package:provider/provider.dart';

class DrawerPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  const DrawerPage({Key key, this.auth, this.logoutCallback}) : super(key: key);
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String imageUrl =
      "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png";

  String nameSurname;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var memberImage = Provider.of<AuthUser>(context).getImageUrl;
    if (memberImage != null && memberImage != "") {
      imageUrl = memberImage;
    }
    var memberNameSurname =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_NAMESURNAME);
    if (memberNameSurname != null && memberNameSurname != "") {
      nameSurname = memberNameSurname;
    } else 
    {
      nameSurname= AppLocalizations.of(context).translate('nameSurname');
    }

/*
    var memberImage =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_IMAGE);
    if (memberImage != null && memberImage != "") {
      imageUrl = memberImage;
    }
    var memberNameSurname =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_NAMESURNAME);
    if (memberNameSurname != null && memberNameSurname != "") {
      nameSurname = memberNameSurname;
    }*/

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(nameSurname),
            accountEmail: Text("fdsffdsf"),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            /*
            decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover)),
                  child: Text(nameSurname,  style: TextStyle(color: Colors.white, fontSize: 25.0)),
            */
            /*
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 100.0,
                  ),
                  Text(
                   SharedManager.instance.getStringValue(SharedKeys.MEMBER_NAMESURNAME),
                   style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ],
              ),
              
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),*/
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context).translate('myProfile')),
            onTap: () {
              String _memberKey =
                  SharedManager.instance.getStringValue(SharedKeys.MEMBERID);

              FirebaseDatabase _database = FirebaseDatabase.instance;
              Member ownProfileMember;
              var _todoQuery =
                  _database.reference().child("member/$_memberKey");

              _todoQuery.once().then((value) {
                setState(() {
                  ownProfileMember = Member.fromSnapshot(value);
                  this._gotoProfile(ownProfileMember);
                });
              });
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.list),
            title: Text(AppLocalizations.of(context).translate('activityList')),
            //  trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.userCheck),
            title: Text(AppLocalizations.of(context).translate('followedUsers')),
            //  trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),
/*
          ExpansionTile(
            leading: Icon(Icons.perm_device_information),
            title: Text('Kurumsal'),
            trailing: Icon(Icons.arrow_drop_down),
            children: <Widget>[
              ListTile(
                title: Text('Biz Kimiz'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, "/bizkimiz");
                },
              ),
              ListTile(
                title: Text('Tarihçemiz'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, "/tarihcemiz");
                },
              ),
              ListTile(
                title: Text('Kurumsal'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, "/kurumsal");
                },
              ),
            ],
          ),
*/
          ListTile(
            leading: Icon(FontAwesomeIcons.thList),
            title: Text(AppLocalizations.of(context).translate('myOpenActivities')),
            onTap: () {
              Navigator.pushNamed(context, "/myactivity");
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.edit),
            title: Text(AppLocalizations.of(context).translate('configurations')),
            onTap: () {
              Navigator.pushNamed(context, "/configurationPage");
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(AppLocalizations.of(context).translate('logOut')),
            onTap: () {
              signOut();
            },
          ),
        ],
      ),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _gotoProfile(Member ownProfileMember) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return MemberProileTabbar(
        member: ownProfileMember
      );
    }));
  }
}
