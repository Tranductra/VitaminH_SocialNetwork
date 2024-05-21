import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';

import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';

class FollowersScreen extends StatefulWidget {
  final String uid;
  const FollowersScreen({super.key, required this.uid});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  String username = '';
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      username = (userSnap.data()! as dynamic)['username'];
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('following', arrayContains: widget.uid)
              .get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('${username} following is empty'));
            }

            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                if ((snapshot.data! as dynamic)
                    .docs[index]['followers']
                    .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  isFollowing = true;
                }

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]
                                ['uid'])));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl']),
                    ),
                    title: Text(
                        (snapshot.data! as dynamic).docs[index]['username']),
                    trailing: (FirebaseAuth.instance.currentUser!.uid ==
                            (snapshot.data! as dynamic).docs[index]['uid'])
                        ? const Text(
                            '(You)',
                            style: TextStyle(color: Colors.blueAccent),
                          )
                        : isFollowing
                            ? SizedBox(
                                width: 100,
                                child: FollowButton(
                                    function: () async {
                                      await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          (snapshot.data! as dynamic)
                                              .docs[index]['uid']);
                                      setState(() {
                                        isFollowing = false;
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    boderColor: Colors.grey,
                                    text: 'Unfollow',
                                    textColor: Colors.black),
                              )
                            : SizedBox(
                                width: 100,
                                child: FollowButton(
                                    function: () async {
                                      await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          (snapshot.data! as dynamic)
                                              .docs[index]['uid']);
                                      setState(() {
                                        isFollowing = true;
                                      });
                                    },
                                    backgroundColor: Colors.blue,
                                    boderColor: Colors.blue,
                                    text: 'Follow',
                                    textColor: Colors.white),
                              ),
                  ),
                );
              },
            );
          }),
    );
  }
}
