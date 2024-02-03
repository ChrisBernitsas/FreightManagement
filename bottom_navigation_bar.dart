import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/auth_page.dart';
import '../pages/create_shipment.dart';
import '../pages/login_page.dart';
import '../pages/myhomepage.dart';
import '../pages/truckerhome.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (globalState.isTrucker) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TruckerHome()), // Navigate to TruckerHome if isTrucker is true
                  );
                } else if (globalState.isAdmin) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage()), // Navigate to MyHomePage if isAdmin is true
                  );
                }
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthPage()));
                _logoutFunction();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _logoutFunction() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Create Shipment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Log Out',
        ),
      ],
      currentIndex: 0, // Set the initial active tab
      onTap: (int index) {
        // Handle navigation to different pages based on the selected tab
        if (index == 2) {
          _confirmLogout(context);
        } else {
          switch (index) {
            case 0:
              if (globalState.isTrucker) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TruckerHome()), // Navigate to TruckerHome if isTrucker is true
                );
              } else if (globalState.isAdmin) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage()), // Navigate to MyHomePage if isAdmin is true
                );
              }
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CreateShipmentPage()),
              );
              break;
          }
        }
      },
    );
  }
}
