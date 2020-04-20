import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/base/base_auth.dart';

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

  String nameSurname = "Ad Soyad";
  @override
  void initState() {
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {

    var memberImage =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_IMAGE);
    if (memberImage != null && memberImage != "") {
      imageUrl = memberImage;
    }
    var memberNameSurname =
        SharedManager.instance.getStringValue(SharedKeys.MEMBER_NAMESURNAME);
    if (memberNameSurname != null && memberNameSurname != "") {
      nameSurname = memberNameSurname;
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(nameSurname), 
            accountEmail: Text("fdsffdsf"),
            currentAccountPicture:
             ClipRRect(
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
            title: Text('Profilim'),
             onTap: () {
              Navigator.pushNamed(context, "/myProfile");
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Aktivite Sayfası'),
            trailing: Icon(Icons.arrow_right),
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
            leading: Icon(Icons.local_laundry_service),
            title: Text('Aktivitelerim'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, "/myactivity");
            },
          ),
           ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text('Ayarlar'),
            onTap: () {
                 Navigator.pushNamed(context, "/configurationPage");
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Çıkış yap'),
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
}
