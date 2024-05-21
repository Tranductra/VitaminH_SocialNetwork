import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/chat_screen.dart';
import 'package:instagram_flutter/screens/followers_screen.dart';
import 'package:instagram_flutter/screens/following_screen.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController controller;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    setState(() {});
    // TODO: implement initState
    super.initState();
    getData();
    _tabController = TabController(length: 3, vsync: this);
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid',
              isEqualTo: FirebaseAuth.instance.currentUser!
                  .uid) // uid khong co dau nen khong hien thi duoc
          .get();

      postLen = postSnap.docs.length;
      userData = (userSnap.data()! as dynamic);

      followers = (userSnap.data()! as dynamic)['followers'].length;
      following = (userSnap.data()! as dynamic)['following'].length;
      isFollowing = (userSnap.data()! as dynamic)['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<String> _getThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    return thumbnail!;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(userData['username']),
                centerTitle: false,
                actions: [
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                      title: const Text(
                                        'Menu',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      children: [
                                        const Divider(),
                                        SimpleDialogOption(
                                          onPressed: () {},
                                          child: const Text('A'),
                                        ),
                                        const Divider(),
                                        SimpleDialogOption(
                                          onPressed: () {},
                                          child: const Text('B'),
                                        ),
                                        const Divider(),
                                        SimpleDialogOption(
                                          onPressed: () {},
                                          child: const Text('C'),
                                        )
                                      ],
                                    ));
                          },
                          icon: const Icon(Icons.more_vert))
                      : IconButton(
                          onPressed: () async {
                            DocumentSnapshot userSnap = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(widget.uid)
                                .get();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    receiverUsername: userSnap['username'],
                                    receiverId: userSnap['uid'])));
                          },
                          icon: const Icon(Icons.messenger_outline))
                ]),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(userData['photoUrl'].toString()),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    buildStatColumn(postLen, 'posts'),
                                    InkWell(
                                      child: buildStatColumn(
                                          followers, 'followers'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              FollowersScreen(uid: widget.uid),
                                        ));
                                      },
                                    ),
                                    InkWell(
                                      child: buildStatColumn(
                                          following, 'following'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              FollowingScreen(uid: widget.uid),
                                        ));
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ));
                                            },
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            boderColor: Colors.grey,
                                            text: 'Sign Out',
                                            textColor: primaryColor)
                                        : isFollowing
                                            ? FollowButton(
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                                backgroundColor: Colors.white,
                                                boderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: Colors.black)
                                            : FollowButton(
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                                backgroundColor: Colors.blue,
                                                boderColor: Colors.blue,
                                                text: 'Follow',
                                                textColor: Colors.white)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                // Add the TabBar and TabBarView here
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                        icon: Icon(
                            Icons.grid_on_outlined)), // Replace with your icons
                    Tab(icon: Icon(Icons.slow_motion_video)),
                    Tab(icon: Icon(Icons.send)),
                  ],
                ),
                SizedBox(
                  height: double.maxFinite, // Adjust the height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                              child: Text('No data available.'),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return SizedBox(
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      ),

                      // Reels
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('reels')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Center(
                                child: Text('No data available.'),
                              );
                            }
                            return GridView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];

                                  controller = VideoPlayerController.network(snap['reelUrl'])
                                    ..initialize().then((value) => setState(() {
                                      controller.setLooping(true);
                                      controller.setVolume(1);
                                      controller.play();
                                      controller.addListener(() {
                                        if (controller.value.position >= controller.value.duration) {
                                          controller.pause();
                                        }
                                      });
                                    }));
                                  return SizedBox(
                                    child: VideoPlayer(
                                        controller),
                                  );
                                });
                          }),
                      Center(child: Text('Tab 3')),
                    ],
                  ),
                ),
                // vi tri nay
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
