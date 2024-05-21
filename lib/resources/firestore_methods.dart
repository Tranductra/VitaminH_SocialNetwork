
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/reel.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      File file,
      String uid,
      String username,
      String profImage
      ) async {
    String res = 'some error occurred';
    try{
      String postId = Uuid().v1();

      String photoUrl = await StorageMethods().upLoadImageToStorage('posts', file, true);
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          dataPublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson(),);

      res = 'success';
    } catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadReel(
      String description,
      File video,
      String uid,
      String username,
      String profImage
      ) async {
    String res = 'some error occurred';
    try{
      String reelId = Uuid().v1();
      String reelUrl = await StorageMethods().upLoadImageToStorage('reels', video, true);
      Reel reel = Reel(
          description: description,
          uid: uid,
          username: username,
          reelId: reelId,
          dataPublished: DateTime.now(),
          reelUrl: reelUrl,
          profImage: profImage,
          likes: []);

      _firestore.collection('reels').doc(reelId).set(reel.toJson(),);
      res = 'success';
    } catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try{
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> likeReel(String reelId, String uid, List likes) async {
    try{
      if (likes.contains(uid)) {
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if(text.isNotEmpty) {
        String commentId = Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      }else {
        print('Text is impty');
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> reelComment(String reelId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if(text.isNotEmpty) {
        String commentId = Uuid().v1();
        _firestore.collection('reels').doc(reelId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        print('Text is impty');
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deletePost (String postId) async {
    String res = 'Some error occurred';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> followUser(
      String uid,
      String followId,
      ) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });

      }
    } catch(e) {
      res = e.toString();
    }
    return res;
  }



}