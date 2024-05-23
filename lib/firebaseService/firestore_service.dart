import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:images_blabla/firebaseService/storage_service.dart';
import 'package:images_blabla/models/chat.dart';
import 'package:images_blabla/models/reels.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadReels(String description, Uint8List file, String uid,
      String username, String profilePic) async {
    String res = 'Some error occurred';
    try {
      String VideoUrl = await StorageService()
          .uploadToStorage('reels', file, false, true, false);
      String reelsId = const Uuid().v1();
      Reels reels = Reels(
        uid: uid,
        username: username,
        description: description,
        profilePic: profilePic,
        reelsId: reelsId,
        reelsUrl: VideoUrl,
        datePublished: DateTime.now(),
        likes: [],
      );
      _firestore.collection('reels').doc(reelsId).set(reels.toJson());
      res = 'success';
    } catch (e) {
      e.toString();
    }
    return res;
  }

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageService()
          .uploadToStorage('posts', file, true, false, false);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> likeReels(String reelsId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('reels').doc(reelsId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('reels').doc(reelsId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postReels(String reelsId, String text, String uid, String name,
      String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('reels')
            .doc(reelsId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> createChat(String uidFriend, String userId,
      ) async {
    String res = 'Some error occurred';
    try {
      String chatId = const Uuid().v1();
        await _firestore.collection('chats').doc(chatId).set({
        'datePublished': DateTime.now(),
        'userId' : userId,
        'uidFriend' : uidFriend,
      });
      
      res = 'success';
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<String> sendChat(String text, String uid,
      String username, String profilePic) async {
    String res = 'Some error occurred';
    try {
      String chatId = const Uuid().v1();
      String messageId = const Uuid().v1();
      Chat chats = Chat(
        uid: uid,
        username: username,
        profilePic: profilePic,
        text: text,
        datePublished: DateTime.now(),
      );
      _firestore.collection('chats').doc(chatId).collection('message').doc(messageId).set(chats.toJson());
      res = 'success';
    } catch (e) {
      print(e);
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> commentReels(String reelsId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('reels')
            .doc(reelsId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'reelsId': reelsId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

