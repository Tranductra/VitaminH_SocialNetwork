import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/chatting_users_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        title: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Colors.white, // Change to your desired color
            BlendMode.srcIn,
          ),
          child: Image.asset(
            'assets/logo.png',
            height: 64,
            // Specify your SVG image path here
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChattingUsersScreen(),));
          }, icon: const Icon(Icons.message_outlined))
        ],
      ),
      body: Column(
        children: [ 
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 4, 5, 0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.grey)),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1606041008023-472dfb5e530f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Zmxvd2VyfGVufDB8fDB8fHww'),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 1,
                          left: 45,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.white)),
                            child: const Icon(
                              Icons.add_circle,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: Colors.grey)),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1495231916356-a86217efff12?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGZsb3dlcnxlbnwwfHwwfHx8MA%3D%3D'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: Colors.grey)),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGZsb3dlcnxlbnwwfHwwfHx8MA%3D%3D'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: Colors.grey)),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1520763185298-1b434c919102?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZsb3dlcnxlbnwwfHwwfHx8MA%3D%3D'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No post is update'));
                  }

                  else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
