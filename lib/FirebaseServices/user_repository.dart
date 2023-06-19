import 'dart:developer';

import 'package:chatter/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firebaseFirestore;

  UserRepository() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<List<UserData>> fetchAllUsers() async {
    List<UserData> allUsers = [];
    await firebaseFirestore.collection('users').get().then((value) {
      if (value != null) {
        allUsers =
            value.docs.map((user) => UserData.fromJson(user.data())).toList();
      }
    }).catchError((e) {
      log('$e');
      return Future.error('Failed to fetch all users: $e');
    });
    return allUsers;
  }


}
