import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  Future<String> signUpUser({
    required String username,
    required String bio,
    required String email,
    required String password,
    required File file,
  }) async {
    String res = 'Some erro occurred';
    try {
      if (username.isNotEmpty ||
          bio.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .upLoadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl
          );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = 'User isn\'t correct';

    try {
      if(email.isNotEmpty && password.isNotEmpty)
      {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }
      else{
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException
    catch (err) {
      err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> forgotPassword(String email) async {
    String res = 'Some erro occurred';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = 'success';
    } on FirebaseAuthException
    catch (e) {
      res = e.toString();
    }
    return res;

  }
}
