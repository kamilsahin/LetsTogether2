import 'package:flutter/material.dart';

class CommonWidgets {

 static CommonWidgets instance = CommonWidgets._privateConstructor();
 CommonWidgets._privateConstructor();


  Widget get notFoundWidget => Center(
        child: Text("Not Found"),
      );
  
  Widget get waitingWidget => Center(child: CircularProgressIndicator());


  
}