import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:images_blabla/models/user.dart';
import 'package:images_blabla/view/widget/comment_reels.dart';
import 'package:images_blabla/view/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../firebaseService/firestore_service.dart';
import '../../providers/user_provider.dart';

class ReelsWidget extends StatefulWidget {
  final snap;
  const ReelsWidget({Key? key, required this.snap}) : super(key: key);

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget> {
  VideoPlayerController? _videoPlayerController;
  int commentLen = 0;
  bool isLikeAnimating = false;
  
  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.snap['reelsUrl'])
          ..initialize().then((value) {
            setState(() {
              _videoPlayerController!.play();
            });
          });
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('reels')
          .doc(widget.snap['reelsId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  void playPauseVideo() {
    setState(() {
      _videoPlayerController!.value.isPlaying
          ? _videoPlayerController!.pause()
          : _videoPlayerController!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 28;
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            playPauseVideo();
          },
          child: Stack(
            children: [
              VideoPlayer(_videoPlayerController!),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: () {
                      playPauseVideo();
                    },
                    icon: const Icon(Icons.play_arrow),
                    color: Colors.white.withOpacity(0),
                    iconSize: 60),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           colors: [
              //         Colors.black.withOpacity(0.5),
              //         Colors.transparent
              //       ],
              //           begin: const Alignment(0, -0.75),
              //           end: const Alignment(0, 0.1))),
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           colors: [
              //         Colors.black.withOpacity(0.3),
              //         Colors.transparent
              //       ],
              //           end: const Alignment(0, -0.75),
              //           begin: const Alignment(0, 0.1))),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        flex: 14,
                        child: Container(
                          child: Column(children: [
                            ListTile(
                              dense: true,
                              minLeadingWidth: 0,
                              horizontalTitleGap: 12,
                              title: Row(
                                children: [
                                  Text(
                                    widget.snap['username'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    DateFormat.yMMMd().format(
                                        widget.snap['datePublished'].toDate()),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundImage:
                                    NetworkImage(widget.snap['profilePic']),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ExpandableText(
                                  widget.snap['description'],
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  expandText: 'more',
                                  collapseText: 'less',
                                  expandOnTextTap: true,
                                  collapseOnTextTap: true,
                                  maxLines: 1,
                                  linkColor: Colors.grey,
                                ),
                              ),
                            ),
                            const ListTile(
                              dense: true,
                              minLeadingWidth: 0,
                              horizontalTitleGap: 5,
                              title: Text(
                                'music - original music',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              leading: Icon(
                                Icons.graphic_eq_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    LikeAnimation(
                                      smallLike: true,
                                      isAnimating: widget.snap['likes']
                                          .contains(user.uid),
                                      child: IconButton(
                                        icon: widget.snap['likes']
                                                .contains(user.uid)
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 28,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                        onPressed: () {
                                          FireStoreService().likeReels(
                                            widget.snap['reelsId'].toString(),
                                            user.uid,
                                            widget.snap['likes'],
                                          );
                                        },
                                      ),
                                    ),
                                    Text('${widget.snap['likes'].length}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CommentReels(
                                                reelsId: widget.snap['reelsId']
                                                    .toString(),
                                              );
                                            });
                                      },
                                      icon:const Icon(Icons.chat_bubble_outline),
                                      color: Colors.white,
                                      iconSize: iconSize,
                                    ),
                                    Text('$commentLen',
                                        style:const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon:const Icon(Icons.send_outlined),
                                      color: Colors.white,
                                      iconSize: iconSize,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon:const Icon(Icons.more_horiz),
                                      color: Colors.white,
                                      iconSize: iconSize,
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  widget.snap['profilePic']))),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
