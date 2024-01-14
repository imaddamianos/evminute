import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(33.8836224, 35.5548414),
    zoom: 12,
  );

  final Set<Marker> _markers = <Marker>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargers Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // Add your customized markers
          _addMarker(
            const LatLng(33.8837062, 35.5583195),
            'BMW',
            'EV Charger AC 22kwh',
            'assets/images/bmwcharger1.png', // Replace with your image asset
          );
          _addMarker(
            const LatLng(33.8827062, 35.5593195),
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
