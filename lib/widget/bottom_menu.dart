import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/home_view.dart';
import '../view/notification_view.dart';
import '../view/profile_view.dart';
import '../view/reels_view.dart';
import '../view/search_view.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;
  final homeScreenItems = [
    const HomeView(),
    const SearchView(),
    const ReelsView(),
    const NotificationView(),
    ProfileView(uid: FirebaseAuth.instance.currentUser!.uid)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: homeScreenItems[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
            currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Reels'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),    
          ],
        ));
  }
}
