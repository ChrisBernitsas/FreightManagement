// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../components/bottom_navigation_bar.dart';
import 'login_page.dart';
import 'maptracker.dart';

class TruckerHome extends StatefulWidget {
  @override
  _TruckerHomeState createState() => _TruckerHomeState();
}

class _TruckerHomeState extends State<TruckerHome> {
  List<LatLng> routePoints = [
    LatLng(37.7749, -122.4194),
    LatLng(34.0522, -118.2437),
    LatLng(41.8781, -87.6298),
  ];

  bool showCheckInPopUp = true;

  @override
  Widget build(BuildContext context) {
    //String userEmail = Provider.of<UserEmail>(context).email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Truck Map'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: MapTruck(route: routePoints),
          ),
          // List of Tasks
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'List of Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show check-in pop-up
          if (showCheckInPopUp) {
            showCheckInDialog();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Future<void> showCheckInDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check In'),
          content: Text('Do you want to check in?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform check-in logic here
                // You can update your server or perform any other necessary actions
                setState(() {
                  showCheckInPopUp = false; // Hide the pop-up after checking in
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Check In'),
            ),
          ],
        );
      },
    );
  }
}


// Add this import statement at the beginning
// import 'dart:async';

// // ...

// class TruckerHome extends StatefulWidget {
//   @override
//   _TruckerHomeState createState() => _TruckerHomeState();
// }

// class _TruckerHomeState extends State<TruckerHome> {
//   List<LatLng> routePoints = []; // List to store route points
//   Timer? routeUpdateTimer;

//   @override
//   void initState() {
//     super.initState();

//     // Initial call to fetch the route
//     fetchRoute();

//     // Set up a periodic task to update the route every 5 seconds
//     routeUpdateTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
//       fetchRoute();
//     });
//   }

//   @override
//   void dispose() {
//     routeUpdateTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> fetchRoute() async {
//     final String apiUrl =
//         'YOUR_API_ENDPOINT'; // Replace with your actual API endpoint

//     // Replace with actual current and end coordinates
//     final String currentLocation = 'YOUR_CURRENT_LOCATION';
//     final String endLocation = 'YOUR_END_LOCATION';

//     //https://bananapeel-891ee.web.app/companies/company1/drivers/driver+""/trips/trip1/points/currentPoint

//     try {
//       final response = await http
//           .get(Uri.parse('$apiUrl?start=$currentLocation&end=$endLocation'));
//       if (response.statusCode == 200) {
//         // Parse the response and update the routePoints
//         setState(() {
//           routePoints = parseRoute(response.body);
//         });
//       } else {
//         print('Failed to fetch route. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching route: $error');
//     }
//   }

//   List<LatLng> parseRoute(String responseBody) {
//     // Parse the response and return the route points
//     // You'll need to adjust this based on the actual response structure
//     // For example, if the response is a JSON array of coordinates, you might do something like:
//     final List<dynamic> data = jsonDecode(responseBody);
//     return data.map((point) {
//       return LatLng(point['latitude'], point['longitude']);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String userEmail = Provider.of<UserEmail>(context).email;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Truck Map'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: MapPage(routes: routePoints),
//           ),
//           // List of Tasks
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               'List of Tasks',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: MyBottomNavigationBar(),
//     );
//   }
// }
