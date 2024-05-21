import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/reel_item.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isFollowing = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore
              .collection('reels')
              .orderBy('dataPublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return PageView.builder(
              itemBuilder: (context, index) {
                if(!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return ReelItem(snapshot: snapshot.data!.docs[index].data());
              },
              controller: PageController(initialPage: 0),
              scrollDirection: Axis.vertical,
            );
          },
        ),
      ),
    );
  }
}
