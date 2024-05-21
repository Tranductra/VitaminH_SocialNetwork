import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({super.key, required this.snap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
              ));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(snap['profilePic']),
              radius: 18,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          child: Text(snap['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid:
                                        FirebaseAuth.instance.currentUser!.uid),
                              ))),
                      Text(
                        ' ' + snap['text'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite),
          )
        ],
      ),
    );
  }
}
