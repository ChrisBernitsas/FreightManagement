import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final List<List<LatLng>> routes;

  MapPage({Key? key, required this.routes}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    // Adding markers and polylines for each route
    for (int routeIndex = 0; routeIndex < widget.routes.length; routeIndex++) {
      List<LatLng> routePoints = widget.routes[routeIndex];

      // Adding markers for each route point
      for (int i = 0; i < routePoints.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId('marker$routeIndex-$i'),
            position: routePoints[i],
            infoWindow: InfoWindow(title: 'Marker $i (Route $routeIndex)'),
          ),
        );
      }

      // Adding polyline for the route
      polylines.add(
        Polyline(
          polylineId: PolylineId('route$routeIndex'),
          points: routePoints,
          color: Color.fromARGB(255, 216, 108, 19),
          width: 4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.routes.first.first,
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
