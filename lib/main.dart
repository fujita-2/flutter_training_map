import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

/*
memo
GoogleCloudPlatformで発行したAPIキーは以下に追記する
　android/app/src/main/AndroidManifest.xml

*/
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId("marker1"),
      position: LatLng(37.4224411,-122.0884808),
      infoWindow: InfoWindow(title: "マーカーテスト１"),
    ),
    const Marker(
      markerId: MarkerId("marker2"),
      position: LatLng(37.42747752203552, -122.08057852883495),
      infoWindow: InfoWindow(title: "マーカーテスト２"),
    ),
  };
  final Set<Polyline> _lines = {
    const Polyline(
      polylineId: PolylineId("line1"),
      points: [
        LatLng(37.42246006639176, -122.08409675340478),
        LatLng(37.42747752203552, -122.08057852883495),
      ],
      color: Colors.blue,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        //onMapCreated: (GoogleMapController controller) {
        //  _controller.complete(controller);
        //},
        markers: _markers,
        polylines: _lines,
        onMapCreated: _goToTheGooglePlex,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheGooglePlex(GoogleMapController controller) async {
    if (await Permission.location.request().isGranted) {
      print('ログ1-1');
      final GoogleMapController controller = await _controller.future;
      print('ログ1-2');
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      print('ログ1-3');
    }
  }

  Future<void> _goToTheLake() async {
    if (await Permission.location.request().isGranted) {
      print('ログ2-1');
      final GoogleMapController controller1 = await _controller.future;
      print('ログ2-2');
      controller1.animateCamera(CameraUpdate.newCameraPosition(_kLake));
      print('ログ2-3');
    }
  }
}
