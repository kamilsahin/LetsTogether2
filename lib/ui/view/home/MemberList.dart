import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:letstogether/core/helper/shared_manager.dart';
import 'package:letstogether/core/model/entity/member.dart';
import 'package:letstogether/core/services/firebase_service.dart';

class MemberList extends StatefulWidget {
  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
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
        title: Text("Kullanıcılar"),
      ),
       // body: Center(child: SwipeList()));
      body: membersBuilder,
    );
  }

  Widget get membersBuilder => FutureBuilder(
    future: service.getMembers(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.done:
          if (snapshot.hasData) {
            if (snapshot.data is List) {
              return _listMembers(snapshot.data);
            } else if (snapshot.data is Response) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await SharedManager.instance
                    .saveString(SharedKeys.TOKEN, "");
                Navigator.of(context).pop();
              });
            }
          }
          return _notFoundWidget;

        default:
          return _waitingWidget;
      }
    },
  );

  Widget _listMembers(List<Member> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _memberCard(list[index]));
  }


  Widget _memberCard(Member member) {
    return Card(
       elevation: 5,
        child: Container(
          height: 150.0,
          child: Row(
            children: <Widget>[
              Container(
                height: 100.0,
                width: 70.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/letstogether-7fad5.appspot.com/o/einstein-1.png")
                    )
                ),
              ),
              Container(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        member.name +" " + member.surname ,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50))
                          ),
                          child: Text(
                            member.gender.toString(), textAlign: TextAlign.center,),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                        child: Container(
                          width: 260,
                          child: Text(
                            "His genius finally recognized by his idol Chester",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 48, 48, 54)
                            ),),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }




  Widget get _notFoundWidget => Center(
    child: Text("Not Found"),
  );
  Widget get _waitingWidget => Center(child: CircularProgressIndicator());

}

class SwipeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListItemWidget();
  }
}


class ListItemWidget extends State<SwipeList> {
  List items = getDummyList();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(

          itemCount: items.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(items[index]),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
              },
              direction: DismissDirection.endToStart,
              child: Card(
                elevation: 5,
                child: Container(
                  height: 100.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                topLeft: Radius.circular(5)
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png")
                            )
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                items[index],

                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Container(
                                  width: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.teal),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))
                                  ),
                                  child: Text(
                                    "3D", textAlign: TextAlign.center,),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                child: Container(
                                  width: 260,
                                  child: Text(
                                    "His genius finally recognized by his idol Chester",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 48, 48, 54)
                                    ),),


                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "Item ${i + 1}";
    });
    return list;
  }

}
