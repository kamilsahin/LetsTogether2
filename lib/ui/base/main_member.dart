import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/member.dart';

class MainMemberDataModal extends ChangeNotifier {

  Member _mainMember;

  Member get getMainMember => _mainMember;

  void setMainMember(Member data)
  {
    _mainMember = data;
    notifyListeners();
  }

}