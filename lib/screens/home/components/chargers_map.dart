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

  Future<void> _loadMarkers() async {
    await _addMarker(
      const LatLng(33.8837062, 35.5583195),
      'BMW',
      'EV Charger AC 22kwh',
      'assets/images/evChargerPoint.png',
    );

    await _addMarker(
      const LatLng(33.8827062, 35.5593195),
      'Solaris',
      'EV fast chargers',
      'assets/images/evChargerPoint.png',
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargers Map'),
      ),
      body: FutureBuilder(
        future: _loadMarkers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _addMarker(
    LatLng position,
    String title,
    String snippet,
    String imagePath,
  ) async {
    final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.0),
      imagePath,
    );

    _markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: title,
          snippet: snippet,
        ),
        icon: icon,
      ),
    );
  }
}
