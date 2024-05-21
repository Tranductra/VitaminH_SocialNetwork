import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/comments_reel_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/user.dart' as model;
import 'follow_button.dart';
import 'like_animation.dart';

class ReelItem extends StatefulWidget {
  final snapshot;

  const ReelItem({super.key, this.snapshot});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController controller;
  bool play = true;
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool isFollowing = false;

  @override
  void initState() {
    checkFollowing();
    getComments();
    controller = VideoPlayerController.network(widget.snapshot['reelUrl'])
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


    // TODO: implement initState
    super.initState();
  }


  void checkFollowing() async {
    String uid = widget.snapshot['uid'];
    DocumentSnapshot userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (userSnap['followers'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      isFollowing = true;
    }
    return;
  }

  void getComments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reels')
          .doc(widget.snapshot['reelId'])
          .collection('comments')
          .get();
      commentLen = snapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              play = !play;
              if (play) {
                controller.play();
              } else {
                controller.pause();
              }
            });
          },
          onDoubleTap: () async {
            await FirestoreMethods().likeReel(
                widget.snapshot['reelId'], user.uid, widget.snapshot['likes']);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 812,
                child: VideoPlayer(controller),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 450,
          right: 15,
          child: Column(
            children: [
              IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likeReel(widget.snapshot['reelId'],
                        user.uid, widget.snapshot['likes']);
                  },
                  icon: widget.snapshot['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                        )),
              Text(
                '${widget.snapshot['likes'].length}',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentsReelScreen(
                        snap: widget.snapshot),
                  ));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Text(
                commentLen.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.send_outlined,
                color: Colors.white,
                size: 28,
              ),
              const Text(
                '0',
                style: TextStyle(fontSize: 12, color: Colors.white),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 40,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.pause();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(uid: widget.snapshot['uid']),
                      ));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(widget.snapshot['profImage']),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.pause();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(uid: widget.snapshot['uid']),
                      ));
                    },
                    child: Text(
                      widget.snapshot['username'],
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  (widget.snapshot['uid'] == FirebaseAuth.instance.currentUser!.uid)
                      ? const Text(
                          'You',
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      : isFollowing
                          ? SizedBox(
                              width: 100,
                              child: FollowButton(
                                  function: () async {
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        (widget.snapshot['uid']));
                                    setState(() {
                                      isFollowing = false;
                                    });
                                  },
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  boderColor: Colors.grey,
                                  text: 'Unfollow',
                                  textColor: Colors.white),
                            )
                          : SizedBox(
                              width: 100,
                              child: FollowButton(
                                  function: () async {
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        (widget.snapshot['uid']));
                                    setState(() {
                                      isFollowing = true;
                                    });
                                  },
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  boderColor: Colors.blue,
                                  text: 'Follow',
                                  textColor: Colors.white),
                            ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.snapshot['description'],
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
