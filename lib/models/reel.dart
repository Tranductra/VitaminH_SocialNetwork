import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reel {
  final String description;
  final String uid;
  final String username;
  final String reelId;
  final dataPublished;
  final String reelUrl;
  final String profImage;
  final likes;

  Reel(
      {
        required this.description,
        required this.uid,
        required this.username,
        required this.reelId,
        required this.dataPublished,
        required this.reelUrl,
        required this.profImage,
        required this.likes});

  Map<String, dynamic> toJson() => {
    'description': description,
    'uid': uid,
    'username': username,
    'reelId': reelId,
    'dataPublished': dataPublished,
    'reelUrl': reelUrl,
    'profImage': profImage,
    'likes': likes

  };

  static Reel fromSnap(DocumentSnapshot snapshot) {
    var snap = (snapshot.data() as Map<String, dynamic>);
    return Reel(
      description: snap['description'],
      uid: snap['uid'],
      username: snap['username'],
      reelId: snap['reelId'],
      dataPublished: snap['dataPublished'],
      reelUrl: snap['reelUrl'],
      profImage: snap['profImage'],
      likes: snap['likes'],
    );
  }
}
