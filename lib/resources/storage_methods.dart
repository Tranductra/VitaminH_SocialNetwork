import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> upLoadImageToStorage(String childName, File file, bool isPost) async{
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }


    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> upLoadVideoToStorage(String childName, File file) async{
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid).child('uid');

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // adding image to firebase storage
}