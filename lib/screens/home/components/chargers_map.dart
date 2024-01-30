import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_3d_obj/flutter_3d_obj.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(33.8836224, 35.5548414),
    zoom: 12,
  );

  Future<void> _loadMarkers() async {
    final CollectionReference<Map<String, dynamic>> markersCollection =
        FirebaseFirestore.instance.collection('chargers');

    try {
      // Fetch markers from Firestore
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await markersCollection.get();

      // Loop through the documents in the snapshot
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        final Map<String, dynamic> data = document.data();

        // Extract data from the document
        final GeoPoint geoPoint = data['position'] as GeoPoint;
        final LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        final String title = data['title'] as String;
        final String description = data['description'] as String;
        const String image = 'assets/images/evChargerPoint.png';

        // Add the marker using the _addMarker function
        await _addMarker(position, title, description, image);
      }
    } catch (e) {
      // Handle errors, e.g., network issues or Firestore permission issues
      print('Error loading markers: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: devicePixelRatio),
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
