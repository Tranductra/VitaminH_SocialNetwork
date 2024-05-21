import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final dataPublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post(
      {
        required this.description,
        required this.uid,
        required this.username,
        required this.postId,
        required this.dataPublished,
        required this.postUrl,
        required this.profImage,
        required this.likes});

  Map<String, dynamic> toJson() => {
    'description': description,
    'uid': uid,
    'username': username,
    'postId': postId,
    'dataPublished': dataPublished,
    'postUrl': postUrl,
    'profImage': profImage,
    'likes': likes

  };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = (snapshot.data() as Map<String, dynamic>);
    return Post(
      description: snap['description'],
      uid: snap['uid'],
      username: snap['username'],
      postId: snap['postId'],
      dataPublished: snap['dataPublished'],
      postUrl: snap['postUrl'],
      profImage: snap['profImage'],
      likes: snap['likes'],

    );
  }
}
