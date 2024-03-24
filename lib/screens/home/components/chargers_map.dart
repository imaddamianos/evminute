import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  late LatLng _currentPosition;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(33.8836224, 35.5548414),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Your logic to get the current location goes here
    // For demonstration purposes, I'll use a static location
    _currentPosition = const LatLng(33.8836224, 35.5548414);
  }

  Future<void> _loadMarkers() async {
    final CollectionReference<Map<String, dynamic>> markersCollection =
        FirebaseFirestore.instance.collection('chargers');

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await markersCollection.get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        final Map<String, dynamic> data = document.data();
        final GeoPoint geoPoint = data['position'] as GeoPoint;
        final LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        final String title = data['title'] as String;
        final String description = data['description'] as String;
        const String image = 'assets/images/evChargerPoint.png';

        await _addMarker(position, title, description, image);
      }
    } catch (e) {
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
              myLocationEnabled: true, // Show current location
              myLocationButtonEnabled:
                  true, // Show button to go to current location
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
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
          snippet: snippet + '\n Tap to navigate',
          onTap: () {
            _launchMapNavigation(position.latitude, position.longitude);
          },
        ),
        icon: icon,
      ),
    );
  }

  Future<void> _launchMapNavigation(double lat, double lng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
