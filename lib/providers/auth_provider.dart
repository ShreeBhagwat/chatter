import 'dart:developer';

import 'package:chatter/FirebaseServices/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _email = "";
  String _password = "";
  String _errorText = "";
  UserCredential? userCrendentials;
  bool _isError = false;

  bool get isLoading => _isLoading;
  String get email => _email;
  String get password => _password;
  String get errorText => _errorText;
  bool get isError => _isError;

  final userRepository = UserRepository();

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

  Future<void> loginUser() async {
    setLoading(true);

    // try {
    //   final userCredentials =
    //       await userRepository.loginWithEmailAndPassword(email, password);
    // } catch (e) {
    //   log(e.toString());
    //   setErrorText(e.toString());
    // }

    await userRepository
        .loginWithEmailAndPassword(email, password)
        .then((value) {
      if (value != null) {
        userCrendentials = value;
        _isError = false;

        setErrorText('Users Logged in Successfully');
      }
    }).catchError((e) {
      log(e.toString());
      _isError = true;
      setErrorText(e.toString());
      setLoading(false);
    });

    setLoading(false);
  }

  Future<void> signOutUser()async {
    userRepository.signOut();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});
