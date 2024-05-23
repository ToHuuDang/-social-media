import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String uid;
  final String username;
  final String profilePic;
  final String text;
  final DateTime datePublished;

  Chat({
    required this.uid,
    required this.username,
    required this.profilePic,
    required this.text,
    required this.datePublished,
  });
  static Chat fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Chat(
      uid: snapshot['uid'],
      username: snapshot['username'],
      profilePic: snapshot['profilePic'],
      text: snapshot['text'],
      datePublished: snapshot['datePublished'],
    );
  }
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "profilePic": profilePic,
        "text": text,
        'datePublished': datePublished,
      };
}
