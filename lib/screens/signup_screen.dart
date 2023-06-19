import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'all_users_screen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Signup Screen",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your Password",
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async =>
                    registerNewUserToFirebaseWithEmailAndPassword(context),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Sign Up"))
          ],
        ),
      ),
    );
  }

  void registerNewUserToFirebaseWithEmailAndPassword(
      BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final email = emailController.text;
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      log("Email and password cannot be empty");
      return;
    } else {
      // Create user here
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        final user = value.user;
        if (user != null) {
          addUsersDataToFirestoreDb(user.uid, context);
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        log("User creation failed: $error");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User creation failed")));
      });
    }
  }

  void addUsersDataToFirestoreDb(String uid, BuildContext context) {
    var data = {
      "email": emailController.text,
      "name": nameController.text,
      "password": passwordController.text,
      "uid": uid,
      "createdOn": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    FirebaseFirestore.instance.collection('users').add(data).then((value) {
      log("User added to firestore db successfully");
      // Navigate to home screen
      setState(() {
        isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => AllUsersScreen()),
          (route) => false);
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      log("Failed to add user to firestore db: $error");
    });
  }
}
