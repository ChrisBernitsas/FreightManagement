// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/bottom_navigation_bar.dart';
import 'maps_page.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// Example latitude and longitude points
    List<List<LatLng>> routePoints = [
      [
        LatLng(37.7749, -122.4194),
        LatLng(34.0522, -118.2437),
        LatLng(41.8781, -87.6298),
      ],
      [
        LatLng(40.7128, -74.0060),
        LatLng(34.0522, -118.2437),
        LatLng(41.8781, -87.6298),
      ],
    ]; // List of routes

    return Scaffold(
      appBar: AppBar(
        title: Text('Truck Map'),
        automaticallyImplyLeading: false,
      ),
      // body: Column(
      //   children: [
      //     Expanded(child: MapPage(routes: routePoints)),
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: MapPage(routes: routePoints),
          ),
          // List of Tasks
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'List of Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Task 1'),
                  // Add more ListTile widgets for each task
                ),
                ListTile(
                  title: Text('Task 2'),
                ),

                // Add more ListTile widgets for each task
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
