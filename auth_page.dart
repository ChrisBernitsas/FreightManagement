import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginregister_page.dart';
import 'myhomepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapchat) {
              if (snapchat.hasData) {
                return MyHomePage();
              } else {
                return LoginRegister();
              }
            }));
  }
}
