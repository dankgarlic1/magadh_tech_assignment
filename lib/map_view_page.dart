import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapViewPage extends StatefulWidget {
  final List<Map<String, dynamic>> users;

  MapViewPage({required this.users});

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  late GoogleMapController _mapController;
  LatLngBounds? _bounds;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermissions();
  }

  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> requestLocationPermissions() async {
    if (await Permission.location.isGranted) {
      // Location permissions already granted
      calculateBounds();
    } else {
      // Request location permissions from the user
      final permissionStatus = await Permission.location.request();
      if (permissionStatus.isGranted) {
        // Location permissions granted
        calculateBounds();
      } else {
        // Location permissions denied
      }
    }
  }

  void calculateBounds() {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var user in widget.users) {
      final latitude = user['location']['latitude'] as double?;
      final longitude = user['location']['longitude'] as double?;

      if (latitude != null && longitude != null) {
        minLat = min(minLat, latitude);
        maxLat = max(maxLat, latitude);
        minLng = min(minLng, longitude);
        maxLng = max(maxLng, longitude);
      }
    }

    setState(() {
      _bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      _isMapReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: _isMapReady
          ? GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 10,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
          if (_bounds != null) {
            // Move the camera to fit the markers within the bounding box
            Timer(Duration(milliseconds: 10000), () {
              _mapController.animateCamera(CameraUpdate.newLatLngBounds(_bounds!, 100.0));
            });
          }
        },
        markers: widget.users.map((user) {
          final latitude = user['location']['latitude'] as double?;
          final longitude = user['location']['longitude'] as double?;

          if (latitude != null && longitude != null) {
            return Marker(
              markerId: MarkerId(user['_id'].toString()),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: user['name'],
                snippet: user['email'],
              ),
            );
          } else {
            // If latitude or longitude is null, skip adding the marker
            return null;
          }
        }).whereType<Marker>().toSet(),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
