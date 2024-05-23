import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:images_blabla/firebaseService/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';

class CommentReels extends StatefulWidget {
  final reelsId;
  const CommentReels({Key? key, required this.reelsId}) : super(key: key);

  @override
  State<CommentReels> createState() => _CommentReelsState();
}

class _CommentReelsState extends State<CommentReels> {
  TextEditingController commentEditingController = TextEditingController();

  void postReels(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreService().commentReels(
        widget.reelsId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        print(res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return SizedBox(
      height: 700,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bình luận',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
            );
          }),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_outlined),
              color: Colors.black,
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
            .collection('reels')
            .doc(widget.reelsId)
            .collection('comments')
            .snapshots(),
          builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) =>
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    snapshot.data!.docs[index].data()['profilePic'],
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: snapshot.data!.docs[index].data()['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                              ),
                              TextSpan(
                                text: ' ${snapshot.data!.docs[index].data()['text']}',
                                style:const TextStyle(color: Colors.black)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.yMMMd().format(
                              snapshot.data!.docs[index].data()['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.favorite,
                    size: 16,
                  ),
                )
              ],
                ),
              ),
            );
          }
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentEditingController,
                      decoration: InputDecoration(
                        hintText: 'Bình luận bởi ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => postReels(
                    user.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Gửi',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
