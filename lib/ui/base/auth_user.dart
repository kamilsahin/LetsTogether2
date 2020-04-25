import 'package:flutter/material.dart';
import 'package:letstogether/core/helper/shared_manager.dart';

class AuthUser extends ChangeNotifier {
 
  String _imageUrl;
  
  String get getImageUrl => _imageUrl;
  
  void setImageUrl(String imageUr) { 
    _imageUrl = imageUr;
    SharedManager.instance.saveString(SharedKeys.MEMBER_IMAGE,imageUr);
    notifyListeners();
  }
   
}