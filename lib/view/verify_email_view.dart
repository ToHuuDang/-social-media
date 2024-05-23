
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:images_blabla/routes/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Vui lòng xác nhận Email của bạn:'),
            const Text('Chúng tôi sẽ gửi liên kết xác nhận email của bạn qua email:'),
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text('gửi liên kết xác minh')),
            TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                      BottomMenuRoute, (route) => false);
            }, child: const Text('Đã xác minh')),
            TextButton(onPressed: ()async{
              try{
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(LoginViewRoute, (route) => false);
              }on FirebaseAuthException catch (e){
                print(e.code);
              }
            }, child: const Text('Đăng xuất')),
          ],
        ),
      ),
    );
  }
}
