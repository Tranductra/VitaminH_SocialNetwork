import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/chat_card.dart';
import '../resources/chat_service.dart';

class ChattingUsersScreen extends StatefulWidget {

  const ChattingUsersScreen({Key? key}) : super(key: key);

  @override
  _ChattingUsersScreenState createState() => _ChattingUsersScreenState();
}

class _ChattingUsersScreenState extends State<ChattingUsersScreen> {
  List<String> chattingUsers = [];

  @override
  void initState() {
    super.initState();
    loadChattingUsers();
  }

  Future<void> loadChattingUsers() async {
    List<String> users = await ChatService().getChattingUsers(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      chattingUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: ListView.builder(
        itemCount: chattingUsers.length,
        itemBuilder: (context, index) {
          return ChatCard(uid: chattingUsers[index]);
        },
      ),
    );
  }
}
