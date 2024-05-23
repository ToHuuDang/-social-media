import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_blabla/firebaseService/firestore_service.dart';
import 'package:images_blabla/providers/user_provider.dart';
import 'package:images_blabla/service/service.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';

class AddReelsView extends StatefulWidget {
  const AddReelsView({
    Key? key,
  }) : super(key: key);

  @override
  State<AddReelsView> createState() => _AddReelsViewState();
}

class _AddReelsViewState extends State<AddReelsView> {
  Uint8List? _file;
  File? videoFile;
  bool isLoading = false;
  VideoPlayerController? _videoPlayerController;
  final TextEditingController _descriptionController = TextEditingController();
  _selectVideo(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Tạo một thước phim'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('quay video'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickVideo(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Chọn từ thư viện'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickVideo(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
 

  void postReels(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreService().uploadReels(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Đã xong!',
        );
        clearReels();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearReels() {
    setState(() {
      _file = null;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _videoPlayerController = VideoPlayerController.file()
  //     ..initialize().then((_) {
  //       setState(() {});
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                );
              }),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.upload,
                ),
                onPressed: () => _selectVideo(context),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      postReels(
                        userProvider.getUser.uid,
                        userProvider.getUser.username,
                        userProvider.getUser.photoUrl,
                      );
                    },
                    child: const Text(
                      'Thêm',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userProvider.getUser.photoUrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Viết chú thích'),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _selectVideo(context),
                          child: const Icon(Icons.video_collection_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
