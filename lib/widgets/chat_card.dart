import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/chat_service.dart';
import 'package:intl/intl.dart';

import '../screens/chat_screen.dart';

class ChatCard extends StatefulWidget {
  final String uid;
  const ChatCard({super.key, required this.uid});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  var userData = {};
  late String lastMessage = '';
  var messageData = {};
  bool isLastMessage = false;


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
      userData = (userSnap.data()! as dynamic);

      DocumentSnapshot? lastMessageSnap = await ChatService()
          .getLastMessage(widget.uid, FirebaseAuth.instance.currentUser!.uid);
      messageData = (lastMessageSnap!.data()! as dynamic);
      lastMessage = messageData['message'];


      if ((lastMessageSnap.data()! as dynamic)['receiverId'] == widget.uid) {
        isLastMessage = true;
      }
      setState(() {});
    } catch (e) {
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (userData.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(
                  receiverUsername: userData['username'],
                  receiverId: userData['uid'])));
        }
      },
      child: ListTile(
          leading: CircleAvatar(
              radius: 40,
              backgroundImage: userData['photoUrl'] != null
                  ? NetworkImage(userData['photoUrl'])
                  : const NetworkImage(
                      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fgithub.com%2Fmozilla%2Fhotdish%2Fissues%2F264&psig=AOvVaw3BY1ZewW8JfOcTvEchW-ND&ust=1715159492880000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCLjzmJOZ-4UDFQAAAAAdAAAAABAE') // Thay 'path_to_placeholder_image' bằng đường dẫn đến ảnh placeholder
              ),
          title: Text(
            userData['username'].toString(),
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: isLastMessage
              ? Text(
                  'You: ${lastMessage}',
                  style: const TextStyle(color: Colors.grey),
                )
              : Text(
                  lastMessage,
                  style: const TextStyle(color: Colors.grey),
                ),
        trailing: messageData['timestamp'] != null
            ? Text(DateFormat.Hm().format(messageData['timestamp'].toDate()))
            : Text(''),// hoặc Text('Unknown') hoặc bất kỳ chuỗi nào bạn muốn hiển thị khi timestamp null
      ),
    );
  }
}
