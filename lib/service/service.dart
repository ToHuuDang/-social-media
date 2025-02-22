import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagepicker = ImagePicker();

  XFile? file = await imagepicker.pickImage(source: source);
  if(file != null){
    return await file.readAsBytes();
  }
  print('No images select');
}
pickVideo(ImageSource source) async {
  final ImagePicker pickvideo = ImagePicker();

  XFile? file = await pickvideo.pickVideo(source: source);
  if(file != null){
    return await file.readAsBytes();
  }
  print('No video select');
}
// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
