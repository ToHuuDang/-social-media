import 'package:flutter/material.dart';

import '../firebaseService/auth_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthService _authMethods = AuthService();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUser();
    _user = user;
    notifyListeners();
  }
}