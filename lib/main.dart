import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:images_blabla/providers/user_provider.dart';
import 'package:images_blabla/routes/routes.dart';
import 'package:images_blabla/view/add_post.view.dart';
import 'package:images_blabla/view/home_view.dart';
import 'package:images_blabla/view/register_view.dart';
import 'package:images_blabla/view/reset_password_view.dart';
import 'package:images_blabla/view/verify_email_view.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view/login_view.dart';
import 'widget/bottom_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          LoginViewRoute: (context) => const LoginView(),
          RegisterViewRoute: (context) => const Registerview(),
          HomeViewRoute: (context) => const HomeView(),
          VerifyEmailViewRoute: (context) => const VerifyEmailView(),
          ResetPasswordViewRoute: (context) => const ResetPasswordView(),
          BottomMenuRoute: (context) => const BottomMenu(),
          AddPostViewRoute: (context) => const AddPostView(),
          HomePageRoute: (context) => const HomePage(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const BottomMenu();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
