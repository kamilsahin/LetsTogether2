import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageOperations {

 static ImageOperations instance = ImageOperations._privateConstructor();
 ImageOperations._privateConstructor();

 Future<File> chooseFile() async {
    return await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 300,
    );
  }
  
}