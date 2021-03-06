import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart' as gsi;
import 'package:http/http.dart' as http;
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/student.dart';
import 'package:letstogether/core/model/entity/user.dart';
import 'package:letstogether/core/others/firebase_service.dart';
import 'package:letstogether/core/services/google_signin.dart';
import 'package:letstogether/ui/base/common_widgets.dart';

class FireHomeView extends StatefulWidget {
  @override
  _FireHomeViewState createState() => _FireHomeViewState();
}

class _FireHomeViewState extends State<FireHomeView> {
  FirebaseService service;
  @override
  void initState() {
    super.initState();
    service = FirebaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GoogleSignHelper.instance.user == null
            ? CircleAvatar()
            : gsi.GoogleUserCircleAvatar(
          identity: GoogleSignHelper.instance.user,
        ),
      ),
      body: studentsBuilder,
    );
  }

  Widget get studentsBuilder => FutureBuilder(
    future: service.getStudents(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.done:
          if (snapshot.hasData) {
            if (snapshot.data is List) {
              return _listStudent(snapshot.data);
            } else if (snapshot.data is http.Response) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await SharedManager.instance
                    .saveString(SharedKeys.TOKEN, "");
                Navigator.of(context).pop();
              });
            }
          }
          return CommonWidgets.instance.notFoundWidget;

        default:
          return CommonWidgets.instance.waitingWidget;
      }
    },
  );

  Widget get userFutureBuilder => FutureBuilder<List<User>>(
    future: service.getUsers(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.done:
          if (snapshot.hasData)
            return _listUser(snapshot.data);
          else
            return CommonWidgets.instance.notFoundWidget;
          break;
        default:
          return CommonWidgets.instance.waitingWidget;
      }
    },
  );

  Widget _listUser(List<User> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _userCard(list[index]));
  }

  Widget _listStudent(List<Student> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _studentCard(list[index]));
  }

  Widget _userCard(User user) {
    return Card(
      child: ListTile(
        title: Text(user.name),
      ),
    );
  }

  Widget _studentCard(Student student) {
    return Card(
      child: ListTile(
        title: Text(student.name),
        subtitle: Text(student.number.toString()),
      ),
    );
  }
 
}