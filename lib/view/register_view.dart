import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_blabla/routes/routes.dart';
import 'package:images_blabla/service/service.dart';

import '../firebaseService/auth_service.dart';

class Registerview extends StatefulWidget {
  const Registerview({Key? key}) : super(key: key);

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void initState() {
    final username = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    super.initState();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon app
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              //name app
              const Text(
                'HandBook',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _username,
                    autocorrect: false,
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Tên hiện thị", border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // email text field
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _email,
                    autocorrect: false,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Email", border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //password text field
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    autofocus: false,
                    decoration: const InputDecoration(
                        hintText: "Password", border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
        
              const SizedBox(
                height: 10,
              ),
        
              InkWell(
                onTap: () async {
                  final email = _email.text;
                  final password = _password.text;
                  final username = _username.text;
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    final user = await AuthService().SingUpUser(
                      email: email,
                      password: password,
                      username: username,
                      file: _image!,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        VerifyEmailViewRoute, (route) => false);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      _isLoading = false;
                    });
                    print(e);
                    if (e.code == 'email-already-in-use') {
                      print('email-already-in-use');
                    } else if (e.code == 'weak-password') {
                      print('weak-password');
                    } else if (e.code == 'invalid-email') {
                      print('invalid-email');
                    } else if (e.code == 'network-request-failed') {
                      print('network-request-failed');
                    } else if (e.code == 'unknown') {
                      print('unknown');
                    }
                  }
        
                  print(UserCredential);
                },
                child: Container(
                    width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(12),
                          color: Colors.blue
                        ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: Colors.white,),
                          )
                        : const Text('Register',style: TextStyle(color: Colors.white),),
                        ),
              ),
        
              const SizedBox(
                height: 10,
              ),
        
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (route) => false);
                  },
                  child: const Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
