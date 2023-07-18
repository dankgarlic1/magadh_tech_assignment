import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewPage extends StatefulWidget {
  final List<Map<String, dynamic>> users;

  MapViewPage({required this.users});

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(28.5535, 77.2588), // Set initial map location
          zoom: 10.0, // Set initial zoom level
        ),
        markers: widget.users.map((user) {
          final location = user['location'];
          return Marker(
            markerId: MarkerId(user['_id']),
            position: LatLng(location['latitude'], location['longitude']),
            infoWindow: InfoWindow(
              title: user['name'],
              snippet: user['email'],
            ),
          );
        }).toSet(),
      ),
    );
  }
}
