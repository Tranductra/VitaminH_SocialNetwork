import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/video_view.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class AddReelScreen extends StatefulWidget {
  const AddReelScreen({super.key});

  @override
  State<AddReelScreen> createState() => _AddReelScreenState();
}

class _AddReelScreenState extends State<AddReelScreen> {
  File? _file;

  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postVideo(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadReel(
          _descriptionController.text, _file!, uid, username, profImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted', context);
        clearVideo();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selecteVideo(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Crete a reel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            const Divider(),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10),
              child: const Text('Take a video'),
              onPressed: () async {
                Navigator.of(context).pop();
                File? file = await pickVideo(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            const Divider(),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                File? file = await pickVideo(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            const Divider(),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void clearVideo() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Create your reel'),
        centerTitle: true,
      ),
      body: Center(
        child: IconButton(
          onPressed: () {
            _selecteVideo(context);
          },
          icon: const Icon(Icons.upload),
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {
            clearVideo();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Add reel'),
        actions: [
          TextButton(
              onPressed: () {
                postVideo(user.uid, user.username, user.photoUrl);
              },
              child: const Text('Post',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 5)),
            const Divider(),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
            ),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none),
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: VideoView(
                video: _file!,
              ),
            )
          ],
        ),
      ),
    );
  }
}
