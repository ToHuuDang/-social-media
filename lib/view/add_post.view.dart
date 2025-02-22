import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_blabla/firebaseService/firestore_service.dart';
import 'package:images_blabla/providers/user_provider.dart';
import 'package:images_blabla/routes/routes.dart';
import 'dart:typed_data';
import 'package:images_blabla/service/service.dart';
import 'package:provider/provider.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({Key? key}) : super(key: key);

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
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

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreService().uploadPost(
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
        clearImage();
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

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        BottomMenuRoute, (route) => false);
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
                onPressed: () => _selectImage(context),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Bài viết mới',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  icon: const Icon(Icons.done),
                  color: Colors.black,
                ),
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
                          onTap: () => _selectImage(context),
                          child: const Icon(Icons.image),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [Image(image: MemoryImage(_file!))],
                  )
                ],
              ),
            ),
          );
  }
}
