// // ignore_for_file: prefer_const_constructors
// import 'package:bananas/components/my_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key, this.onTap});

//   final Function()? onTap;

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   void signUserUp() async {
//     try {
//       if (passwordController.text == confirmPasswordController.text) {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//             email: emailController.text, password: passwordController.text);
//       }
//     } on FirebaseAuthException catch (e) {
//       wrongMsg();
//     }
//   }

//   void wrongMsg() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const AlertDialog(
//             title: Text(
//                 'Passwords do not match or it must be at least 6 characters.'),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register Page'),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   hintText: 'Email',
//                   border: InputBorder.none,
//                   icon: Icon(Icons.email, color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: 'Password',
//                   border: InputBorder.none,
//                   icon: Icon(Icons.lock, color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black, width: 2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextField(
//                 controller: confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: 'Confirm Password',
//                   border: InputBorder.none,
//                   icon: Icon(Icons.lock, color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
//             MyButton(
//               onTap: signUserUp,
//               text: 'Sign Up',
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Already a member?'),
//                 SizedBox(
//                   width: 4,
//                 ),
//                 GestureDetector(
//                   onTap: widget.onTap,
//                   child: Text('Login here',
//                       style: TextStyle(
//                           color: Colors.blue, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors
import 'package:bananas/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, this.onTap}) : super(key: key);

  final Function()? onTap;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signUserUp() async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
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
          title:
              Text('Passwords do not match or must be at least 6 characters.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
        backgroundColor: Colors.white,
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
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: InputBorder.none,
                  icon: Icon(Icons.lock, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 32),
            MyButton(
              onTap: signUserUp,
              text: 'Sign Up',
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already a member?'),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login here',
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
