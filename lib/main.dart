import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'presentation/greenspace_icons_icons.dart';


void main() => runApp(MyApp());

String _mapStyle;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position userLocation;

  @override
  void initState() {
    _getLocation();
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(_mapStyle);
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToNearestGreenSpace,
        label: Text('Nearest Greenspace'),
        icon: Icon(GreenspaceIcons.flower_tulip),
      ),
    );
  }

  Future<void> _goToNearestGreenSpace() async {
    print("Find and navigate to nearest green space");
    // TODO: use GooglePlaces to find nearest green spaces and show in drawer or on Map
  }

  Future<void> _changeCameraPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(getCameraPositionFromPosition(position)));
  }

  CameraPosition getCameraPositionFromPosition(Position location) {
    return CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 14.4746,
    );
  }

  Future<void> _getLocation() async {
    Position currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("locationLatitude: ${currentLocation.latitude}");
    print("locationLongitude: ${currentLocation.longitude}");
    _changeCameraPosition(currentLocation);
  }
}
