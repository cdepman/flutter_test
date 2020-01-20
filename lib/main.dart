import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'presentation/greenspace_icons_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


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

  Position userLocation;
  bool isLoading;

  @override
  void initState() {
    isLoading = true;
    _getLocation();
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  Widget get _pageToDisplay {
    if (isLoading) {
      return _loadingView;
    } else {
      return _mapView;
    }
  }

  Widget get _loadingView {
    return new Center(
      child: new SpinKitFadingCube(
        color: Colors.greenAccent,
        size: 50.0,
      ),
    );
  }
  
  Widget get _mapView {
    return new GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      initialCameraPosition: getCameraPositionFromPosition(userLocation),
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(_mapStyle);
        _controller.complete(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _pageToDisplay,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToNearestGreenSpace,
        label: Text('Find Nature'),
        icon: Icon(GreenspaceIcons.flower_tulip),
      ),
    );
  }

  Future<void> _goToNearestGreenSpace() async {
    print("Find and navigate to nearest green space");
    // TODO: use GooglePlaces to find nearest green spaces and show in drawer or on Map
  }

  // Future<void> _changeCameraPosition(Position position, String source) async {
  //   print("changing camera location from: {source}");
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(getCameraPositionFromPosition(position)));
  // }

  CameraPosition getCameraPositionFromPosition(Position postition) {
    return CameraPosition(
      target: LatLng(postition.latitude, postition.longitude),
      zoom: 14.4746,
    );
  }

  Future<void> _getLocation() async {
    Position currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() => isLoading = false);
    userLocation = currentLocation;
  }
}
