import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/chat_service.dart';
import 'package:instagram_flutter/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../providers/user_provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUsername;
  final String receiverId;

  const ChatScreen(
      {super.key, required this.receiverUsername, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // text Controller;
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final ChatService _chatService = ChatService();
  sendmessage() async {
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text.trim());
      _messageController.clear();
    }
  }

  Widget _buildMessageList() {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text('Error');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

   // is current user
   bool isCurrentUser = data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
   // align message to the right if sender is the current user, otherwise left
   var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
   return Container(
      alignment: alignment,
       child: Column(
         crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
         children: [
           ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
         ],
       ));
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          // display all messages
          Expanded(child: _buildMessageList()),
          // user input
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Send as ${user.username}',
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  sendmessage();
                  setState(() {
                    _messageController.text = '';
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                        color: Colors.blueAccent
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
