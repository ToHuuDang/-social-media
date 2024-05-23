import 'dart:typed_data';
import 'package:images_blabla/firebaseService/storage_service.dart';
import 'package:images_blabla/models/user.dart' as models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get user
  Future<models.User> getUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return models.User.fromSnap(documentSnapshot);
  }

  // Sing up user
  Future<String> SingUpUser(
      {required String username,
      required String email,
      required String password,
      required Uint8List file}) async {
    String res = 'some error occurred';
    try {
      if (username.isNotEmpty || email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageService()
            .uploadToStorage('profilePics', file, false, false,false);
        models.User user = models.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: '',
          followers: [],
          following: [],
        );
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'success';
      }
    } catch (err) {
      print(err);
    }
    return res;
  }
}
