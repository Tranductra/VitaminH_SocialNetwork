import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// pickImage(ImageSource source) async{
//   final ImagePicker _imagePicker = ImagePicker();
//   XFile? _file = await _imagePicker.pickImage(source: source);
//   if(_file != null){
//     return await _file.readAsBytes();
//   }
//   print('No image selected');
// }

Future<File?> pickImage(ImageSource source) async {
  File? image;
  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: source,
    maxHeight: 720,
    maxWidth: 720,
  );

  if (file != null) {
    image = File(file.path);
  }

  return image;
}

Future<File?> pickVideo(ImageSource source) async {
  File? video;
  final picker = ImagePicker();
  final file = await picker.pickVideo(
    source: source,
    maxDuration: const Duration(minutes: 5),
  );

  if (file != null) {
    video = File(file.path);
  }

  return video;
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content))
  );
}