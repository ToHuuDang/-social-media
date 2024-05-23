import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:images_blabla/routes/routes.dart';

Future<void> saveTokenToDatabase(String token) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'tokens': FieldValue.arrayUnion([token]),
  });
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _token;

  Future<void> setupToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token!);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  @override
  void initState() {
    final email = TextEditingController();
    final password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Icon app
            const Icon(
              Icons.image,
              size: 100,
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
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "Mật khẩu", border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final UserCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  print(UserCredential);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      BottomMenuRoute, (route) => false);
                  setupToken();
                } on FirebaseAuthException catch (e) {
                  print(e);
                  if (e.code == 'user-not-found') {
                    print('user-not-found');
                  } else if (e.code == 'wrong-password') {
                    print('wrong-password');
                  } else if (e.code == 'invalid-email') {
                    print('invalid-email');
                  } else if (e.code == 'network-request-failed') {
                    print('network-request-failed');
                  } else if (e.code == 'unknown') {
                    print('unknown');
                  } else if (e.code == 'user-disabled') {
                    print(e.code == 'user-disabled');
                  }
                }
              },
              child: Container(child: const Text('Đăng nhập')),
            ),

            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn quên thông tin đăng nhập ư?',
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    child: const Text(
                      'Nhận trợ giúp đăng nhập',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          ResetPasswordViewRoute, (route) => false);
                    },
                  ),
                ],
              ),
            ),

            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RegisterViewRoute, (route) => false);
                },
                child:const Text('Đăng kí'))
          ],
        ),
      ),
    );
  }
}
