import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  static String id = "order_track";
  String orderId = '';
  OrderTrackingPage({Key? key, required this.orderId}) : super(key: key);
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  // final Completer<GoogleMapController> _controller = Completer();
  // static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  // static const LatLng destination = LatLng(37.33429383, -122.06600055);
  //
  // List<LatLng> polylineCoordinates = [];
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _initialPosition = const LatLng(6.8747747, 79.8645194);
  final Set<Marker> _markers = {};
  late double lat;
  late double long;
  String orderIdSp = '';

  void _onMapCreate(GoogleMapController controller) {
    _controller.complete(controller);
  }

  MapType currentMapType = MapType.normal;
  late LatLng user_current_position;
  late LatLng user_update_position = const LatLng(6.8747747, 79.8645194);

  Future<LatLng> getCurrentUserLocation() async {
    // LocationPermission permission = await Geolocator.checkPermission();
    LocationPermission permission = await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() async {
      user_current_position = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(position.latitude.toString()),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Marker', snippet: position.toString()),
        ),
      );
      print('**$user_current_position');
      Fluttertoast.showToast(
          msg:
              ' ${user_current_position.longitude} ** ${user_current_position.latitude} ');
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderIdSp)
          .collection('location')
          .doc('position')
          .set({
        'latitude': user_update_position.latitude,
        'longitude': user_update_position.longitude,
        'name': 'john',
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection('orders').doc(orderIdSp).set({
        'status': 'On the way',
      }, SetOptions(merge: true));
    });

    return user_current_position;
  }

  getRealTimeLocation() {
    // Listen for location updates
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    ).listen((p) {
      setState(() {
        print("*********************************");
        print('$p***');

        try {
          lat = p.latitude;
          long = p.longitude;
          user_update_position = LatLng(p.latitude, p.longitude);
          updateData();
        } catch (e) {
          print(e);
        }
      });
    });
  }

  updateData() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderIdSp)
        .collection('location')
        .doc('position')
        .set({
      'latitude': user_update_position.latitude,
      'longitude': user_update_position.longitude,
      'name': 'john',
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance.collection('orders').doc(orderIdSp).set({
      'status': 'On the way',
    }, SetOptions(merge: true));
  }

  Future _navigateCameraToPosition(LatLng position) async {
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 12),
    ));
  }

  @override
  void initState() {
    getCurrentUserLocation();
    getRealTimeLocation();
    super.initState();
  }

  // MapType currentMapType = MapType.normal;
  // var currentloc = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
  @override
  Widget build(BuildContext context) {
    print(widget.orderId);
    orderIdSp = widget.orderId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 20.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lat : $user_update_position : ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // Text(
                  //   'Long $long :',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(30.0),
            child: GoogleMap(
              onMapCreated: _onMapCreate,
              initialCameraPosition: CameraPosition(
                target: LatLng(user_update_position.latitude,
                    user_update_position.longitude),
                zoom: 12,
              ),
              markers: _markers,
              // markers: {
              //   Marker(
              //     markerId: MarkerId("source"),
              //     position: LatLng(lat, long),
              //   ),
              // },
              // markers: {
              //   Marker(
              //     markerId: MarkerId("source"),
              //     position: user_update_position,
              //   ),
              // },
              mapType: currentMapType,
            ),
          ),
          Positioned(
            bottom: 25,
            left: 05,
            child: FloatingActionButton(
              onPressed: () async {
                await getCurrentUserLocation().then((value) async {
                  await _navigateCameraToPosition(value);
                });
              },
              child: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 65,
            child: FloatingActionButton(
              onPressed: () {
                updateData();
                // setState(() {
                //   currentMapType = (currentMapType == MapType.normal)
                //       ? MapType.satellite
                //       : MapType.normal;
                // });
              },
              child: Icon(
                Icons.map,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            child: Positioned(
                top: 20,
                left: 10,
                child: Text(
                  'Position : $user_update_position',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
