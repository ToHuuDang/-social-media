import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_blabla/providers/user_provider.dart';
import 'package:images_blabla/view/profile_view.dart';
import 'package:images_blabla/widget/bottom_menu.dart';
import 'package:provider/provider.dart';

import '../service/service.dart';

class EditProfileView extends StatefulWidget {
  final uid;
  const EditProfileView({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  Uint8List? _image;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController bio = TextEditingController();
  get uid => FirebaseAuth.instance.currentUser!.uid;

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void updateEmail() async{
    if(email.text.isNotEmpty){
    final user = FirebaseAuth.instance.currentUser!.updateEmail(email.text);
    }
  }
  void updatePhotoUrl() async{
    if(_image != null){
    final user = FirebaseFirestore.instance.collection('users').doc(uid).set({
      'photoUrl' : _image
    });
    }
  }
  updateName()async{
      final user =await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'username' : name.text
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chỉnh sửa trang cá nhân',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              updateName();
              
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Thông báo'),
                  content: Text('Cập nhật thông tin thành công!!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Đóng hộp thoại khi nút được nhấn
                        Navigator.of(context).pop();
                      },
                      child: Text('Đóng'),
                    ),
                  ],
                );
              },
            );
            },
            icon: const Icon(Icons.done),
            color: Colors.black,
          )
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              color: Colors.black,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.red,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(userProvider.getUser.photoUrl),
                        radius: 50,
                      ),
                TextButton(
                    onPressed: () {
                      selectImage();
                    },
                    child: const Text(
                      'Đổi ảnh đại diện',
                      style: TextStyle(fontSize: 16),
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    hintText: 'Tên',
                    labelText: 'Tên',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: bio,
                  decoration: const InputDecoration(
                    hintText: 'Tiểu sử',
                    labelText: 'Tiểu sử',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
