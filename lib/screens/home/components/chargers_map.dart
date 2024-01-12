import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 10,
  );

  final Set<Marker> _markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // Add your customized markers
          _addMarker(
            const LatLng(37.7749, -122.4194),
            'Marker 1',
            'Description for Marker 1',
            'assets/marker_icon.png', // Replace with your image asset
          );
          _addMarker(
            const LatLng(37.7892, -122.4070),
            'Marker 2',
            'Description for Marker 2',
            'assets/marker_icon.png', // Replace with your image asset
          );
        },
      ),
    );
  }

  void _addMarker(
    LatLng position,
    String title,
    String snippet,
    String imagePath,
  ) {
    _markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: title,
          snippet: snippet,
        ),
        // icon: Image.asset(name),
      ),
    );
  }
}
