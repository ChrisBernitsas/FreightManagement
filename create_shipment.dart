// import 'package:flutter/material.dart';
// import '../components/bottom_navigation_bar.dart';

// class SetPointsPage extends StatefulWidget {
//   @override
//   _SetPointsPageState createState() => _SetPointsPageState();
// }

// class _SetPointsPageState extends State<SetPointsPage> {
//   TextEditingController startPointLatController = TextEditingController();
//   TextEditingController startPointLngController = TextEditingController();
//   TextEditingController destinationPointLatController = TextEditingController();
//   TextEditingController destinationPointLngController = TextEditingController();

//   void _sendPointsToBackend() {
//     double? startPointLat = double.tryParse(startPointLatController.text);
//     double? startPointLng = double.tryParse(startPointLngController.text);
//     double? destinationPointLat =
//         double.tryParse(destinationPointLatController.text);
//     double? destinationPointLng =
//         double.tryParse(destinationPointLngController.text);

//     if (startPointLat != null &&
//         startPointLng != null &&
//         destinationPointLat != null &&
//         destinationPointLng != null) {
//       // TODO: Send startPoint and destinationPoint to the backend
//       print('Start Point: ($startPointLat, $startPointLng)');
//       print('Destination Point: ($destinationPointLat, $destinationPointLng)');
//     } else {
//       print('Invalid input. Please enter valid latitude and longitude values.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Set Points'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: startPointLatController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Start Point Latitude (A)',
//                 hintText: 'Enter latitude',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: startPointLngController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Start Point Longitude (A)',
//                 hintText: 'Enter longitude',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: destinationPointLatController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Destination Point Latitude (B)',
//                 hintText: 'Enter latitude',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: destinationPointLngController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Destination Point Longitude (B)',
//                 hintText: 'Enter longitude',
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _sendPointsToBackend,
//               child: Text('Send Points to Backend'),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: MyBottomNavigationBar(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import '../components/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;

class CreateShipmentPage extends StatefulWidget {
  @override
  _CreateShipmentPageState createState() => _CreateShipmentPageState();
}

class _CreateShipmentPageState extends State<CreateShipmentPage> {
  TextEditingController _driverIDController = TextEditingController();
  TextEditingController _startPointLatController = TextEditingController();
  TextEditingController _startPointLngController = TextEditingController();
  TextEditingController _endPointLatController = TextEditingController();
  TextEditingController _endPointLngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Shipment'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _driverIDController,
              decoration: InputDecoration(
                labelText: 'Driver ID',
                hintText: 'Enter Driver ID',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _startPointLatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Start Point Latitude',
                hintText: 'Enter latitude',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _startPointLngController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Start Point Longitude',
                hintText: 'Enter longitude',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _endPointLatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'End Point Latitude',
                hintText: 'Enter latitude',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _endPointLngController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'End Point Longitude',
                hintText: 'Enter longitude',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createShipment();
              },
              child: Text('Create Shipment'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }

  void _createShipment() async {
    // Retrieve data from controllers
    String driverID = _driverIDController.text;
    double startPointLat = double.parse(_startPointLatController.text);
    double startPointLng = double.parse(_startPointLngController.text);
    double endPointLat = double.parse(_endPointLatController.text);
    double endPointLng = double.parse(_endPointLngController.text);

    // Create JSON object
    Map<String, dynamic> shipmentData = {
      'driverID': driverID,
      'startPoint': {'lat': startPointLat, 'lng': startPointLng},
      'endPoint': {'lat': endPointLat, 'lng': endPointLng}
    };

    // Convert to JSON string
    String jsonData = json.encode(shipmentData);

    const String projectId = 'your-project-id';

// Firestore REST API URI for the document
    String url =
        'https://bananapeel-891ee.web.app/companies/company1/drivers/driver${driverID}/trips/trip1/client';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print("JSON string posted successfully.");
      } else {
        print(
            "Failed to post JSON string. Status code: ${response.statusCode}. Response: ${response.body}");
      }
    } catch (e) {
      print("Error posting JSON string: $e");
    }

    //NOW WE NEED TO PUSH jsonData TO THE CLOUD

    // Send JSON data over WebSocket
  }
}
