import 'package:cloud_firestore/cloud_firestore.dart';

class Reels {
  final String uid;
  final String username;
  final String profilePic;
  final String description;
  final String reelsId;
  final String reelsUrl;
  final DateTime datePublished;
  final likes;

  Reels({
    required this.uid,
    required this.username,
    required this.profilePic,
    required this.description,
    required this.reelsId,
    required this.reelsUrl,
    required this.datePublished,
    required this.likes,
  });

  static Reels fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Reels(
      uid: snapshot['uid'],
      username: snapshot['username'],
      profilePic: snapshot['profilePic'],
      description: snapshot['description'],
      reelsId:snapshot['reelsId'],
      reelsUrl:snapshot['reelsUrl'],
      datePublished:snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
  Map<String, dynamic> toJson() =>{
    'uid':uid,
    'username':username,
    'profilePic':profilePic,
    'description':description,
    'reelsId':reelsId,
    'reelsUrl':reelsUrl,
    'datePublished': datePublished,
    'likes':likes,
  };
}
