import 'package:bananas/components/my_button.dart';
import 'package:bananas/pages/truckerhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myhomepage.dart';

class GlobalState {
  // Singleton pattern
  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() => _instance;
  GlobalState._internal();

  bool isAdmin = false;
  bool isTrucker = false;
}

// Usage
GlobalState globalState = GlobalState();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.onTap}) : super(key: key);

  final Function()? onTap;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Redirect based on the selected role
      if (globalState.isTrucker) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TruckerHome()),
        );
      } else if (globalState.isAdmin) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      wrongMsg();
    }
  }

  void wrongMsg() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email or Password'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                  icon: Icon(Icons.email, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  icon: Icon(Icons.lock, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: globalState.isTrucker,
                      onChanged: (value) {
                        setState(() {
                          globalState.isTrucker = value ?? false;
                          globalState.isAdmin = !value!;
                        });
                      },
                    ),
                    Text('Trucker'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: globalState.isAdmin,
                      onChanged: (value) {
                        setState(() {
                          globalState.isAdmin = value ?? false;
                          globalState.isTrucker = !value!;
                        });
                      },
                    ),
                    Text('Admin'),
                  ],
                ),
              ],
            ),
            MyButton(
              onTap: signUserIn,
              text: 'Sign in',
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?'),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
