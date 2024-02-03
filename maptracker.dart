import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTruck extends StatefulWidget {
  final List<LatLng> route;

  MapTruck({Key? key, required this.route}) : super(key: key);

  @override
  _MapTruckState createState() => _MapTruckState();
}

class _MapTruckState extends State<MapTruck> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    // Adding markers for each route point
    for (int i = 0; i < widget.route.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('marker-$i'),
          position: widget.route[i],
          infoWindow: InfoWindow(title: 'Marker $i'),
        ),
      );
    }

    // Adding polyline for the route
    polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: widget.route,
        color: Color.fromARGB(255, 216, 108, 19),
        width: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.route.first,
          zoom: 12,
        ),
        markers: markers,
        polylines: polylines,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
