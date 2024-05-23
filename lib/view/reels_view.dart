import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:images_blabla/view/add_reels_view.dart';
import 'package:images_blabla/view/widget/reels_widget.dart';

class ReelsView extends StatefulWidget {
  const ReelsView({
    Key? key,
  }) : super(key: key);


  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Reels'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>const AddReelsView()));
              },
              icon:const  Icon(Icons.photo_camera_outlined)),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('reels').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.black,
                  child: ReelsWidget(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            );
          }),
    );
  }
}
