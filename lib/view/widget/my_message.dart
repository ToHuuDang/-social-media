import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_blabla/firebaseService/firestore_service.dart';
import 'package:images_blabla/providers/user_provider.dart';
import 'package:images_blabla/view/profile_view.dart';
import 'package:provider/provider.dart';

import '../../service/service.dart';

class MyMessage extends StatefulWidget {
  final uid;
  const MyMessage({Key? key, required this.uid}) : super(key: key);

  get userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  final TextEditingController chatController = TextEditingController();
  Uint8List? _file;
  var userData = {};
  bool isLoading = false;
  
  String get userId => FirebaseAuth.instance.currentUser!.uid;
  

  @override
  void initState() {
    super.initState();
    getData();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  createChat(
    String uidFriend,
    String userId,
  ) {
    FireStoreService().createChat(uidFriend, userId,);
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  sendChat(
    String uid,
    String username,
    String profImage,
  ) async {
    // String chatId = '${widget.uid}_${widget.userId}';
    final res = await FireStoreService()
        .sendChat(chatController.text, uid, username, profImage);
    clearChat();
  }

  void clearChat() {
    setState(() {
      _file = null;
      chatController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(userData['photoUrl']),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Đang hoạt động',
                          style: TextStyle(
                              color: Color.fromARGB(108, 33, 149, 243),
                              fontSize: 10),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call),
                  color: Colors.black,
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 54,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData['username'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileView(uid: userData['uid'])));
                            },
                            child: const Text('Xem trang cá nhân',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: IconButton(
                      onPressed: () {
                        _selectImage(context);
                      },
                      icon: const Icon(Icons.camera_alt),
                    )),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextField(
                          controller: chatController,
                          autocorrect: false,
                          autofocus: false,
                          decoration: const InputDecoration(
                              hintText: "Nhắn tin...",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Expanded(
                        child: IconButton(
                      onPressed: () {
                        // createChat(
                        //   userData['uid'],
                        //   userProvider.getUser.uid,
                        //   userProvider.getUser.username,
                        //   userData['username'],
                        // );
                        sendChat(
                          userProvider.getUser.uid,
                          userProvider.getUser.username,
                          userProvider.getUser.photoUrl,
                        );
                      },
                      icon: const Icon(Icons.send),
                    )),
                  ],
                ),
              ],
            ),
          );
  }
}
