import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restuarant/Screens/payment.dart';

class OrderTracker extends StatefulWidget {
  static String id = "map_screen";
  String orderIdNum = '';

  OrderTracker({Key? key, required this.orderIdNum}) : super(key: key);

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  static const LatLng _initialPosition = const LatLng(7.1432567, 80.566565);
  final _locRef = FirebaseFirestore.instance.collection("test");
  String zzzz = '0';

  MapType currentMapType = MapType.normal;
  late double finalLatitude = 7.143166;
  late double finalLongitude = 80.566621;

  updateLocation(double x, double y) {
    setState(() {
      finalLatitude = x;
      finalLongitude = y;
    });
  }

  late DocumentReference _documentReference;
  late CollectionReference _referenceComments;

  Future getUpdatedLocation() async {
    _documentReference =
        await FirebaseFirestore.instance.collection('orders').doc('$zzzz');
    _referenceComments = await _documentReference.collection('location');

    // QuerySnapshot querySnapshot =
    //     await FirebaseFirestore.instance.collection("test").get();
    QuerySnapshot querySnapshot = await _referenceComments.get();

    setState(() {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var a = querySnapshot.docs[i];
        // print('########################');
        // print(a);
        // print(a['latitude']);
        finalLatitude = a['latitude'];
        finalLongitude = a['longitude'];
        // print(zzzz);
        // print("**************");
        // print(a['latitude']);
        // print(a['longitude']);
        // print("**************");
      }
    });
  }

  @override
  void initState() {
    // getUpdatedLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String zzz = widget.orderIdNum;
    zzzz = zzz;
    getUpdatedLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text('Live tracking'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                  position: LatLng(finalLatitude, finalLongitude),
                  markerId: MarkerId('id'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue)),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(finalLatitude, finalLongitude),
              zoom: 8,
            ),
            // onMapCreated: (GoogleMapController controller) async {
            //   setState(() {
            //     _controller = controller;
            //     _added = true;
            //   });
            // },
          ),
          // Positioned(
          //   bottom: 25,
          //   left: 65,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       setState(() {
          //         currentMapType = (currentMapType == MapType.normal)
          //             ? MapType.satellite
          //             : MapType.normal;
          //       });
          //     },
          //     child: Icon(
          //       Icons.map,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: EdgeInsets.all(30.0),
          //   child: GoogleMap(
          //     initialCameraPosition: CameraPosition(
          //       target: _initialPosition,
          //       zoom: 10,
          //     ),
          //     markers: {
          //       Marker(
          //         markerId: MarkerId('soure'),
          //         position: LatLng(finalLatitude, finalLongitude),
          //       )
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
