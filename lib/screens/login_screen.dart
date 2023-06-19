import 'package:chatter/screens/all_users_screen.dart';
import 'package:chatter/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Login Screen",
                style: TextStyle(fontSize: 24, color: Colors.black),
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
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("New User? Create an account"),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignupScreen()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              child: ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      authNotifier
                          .setErrorText("Please enter email and password");
                      return;
                    }
                    authNotifier.setEmail(emailController.text);
                    authNotifier.setPassword(passwordController.text);

                    await authNotifier.loginUser().then((value) {
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          authNotifier.errorText ?? "Hellllo",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: authNotifier.isError
                            ? Colors.red[200]
                            : Colors.green[600],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });

                    !authNotifier.isError
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AllUsersScreen()))
                        : null;
                  },
                  child: authNotifier.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("Login")),
            )
          ],
        ),
      ),
    );
  }
}
