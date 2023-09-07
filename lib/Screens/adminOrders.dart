import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'order_tracking.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  final CollectionReference orderList =
      FirebaseFirestore.instance.collection('orders');
  final _auth = FirebaseAuth.instance;
  var currentUser;
  var num;

  getUser() {
    currentUser = _auth.currentUser?.uid.toString();
    print(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    getUser();

    // counter();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: StreamBuilder(
        stream: orderList.orderBy('date', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  double tot = documentSnapshot['amount'];

                  return Visibility(
                    visible: (documentSnapshot['status'] == 'Pending' ||
                            documentSnapshot['status'] == 'On the way')
                        ? true
                        : false,
                    child: GestureDetector(
                      onTap: () {
                        // print(documentSnapshot["user_id"]);

                        final _documentReference = FirebaseFirestore.instance
                            .collection('orders')
                            .doc(documentSnapshot.id);

                        final _referenceComments =
                            _documentReference.collection('orderItems');

                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            color: Color(0xff757575),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(30.0)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5.0),
                                    child: Text(
                                      'Your Order Details',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                          color: Colors.green),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: StreamBuilder(
                                      stream: _referenceComments.snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              streamSnapshot) {
                                        if (streamSnapshot.hasData) {
                                          return ListView.builder(
                                            itemCount: streamSnapshot
                                                .data!.docs.length,
                                            itemBuilder: (context, index) {
                                              final DocumentSnapshot
                                                  documentSnapshot =
                                                  streamSnapshot
                                                      .data!.docs[index];

                                              return Column(
                                                children: [
                                                  Container(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(22.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 200,
                                                            // height: 30,
                                                            child: Text(
                                                              ' ${documentSnapshot["itemName"]}',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20.0,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' ${documentSnapshot["quantity"]}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            ' ${documentSnapshot["itemPrice"]}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        return Text('Pending');
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total : ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40.0,
                                        ),
                                      ),
                                      Text(
                                        '$tot',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                        // total = 0;
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order number : ${documentSnapshot.id}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Date : ${documentSnapshot['date']}',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              Text(
                                                'Time : ${documentSnapshot['time']}',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                              Text(
                                                'Mobile : ${documentSnapshot['mobile']}',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Alert(
                                                        context: context,
                                                        desc:
                                                            'Are you going to start the delivery ride ?',
                                                        buttons: [
                                                          DialogButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                          DialogButton(
                                                            color:
                                                                Color.fromRGBO(
                                                                    243,
                                                                    73,
                                                                    73,
                                                                    1.0),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      OrderTrackingPage(
                                                                    orderId:
                                                                        '${documentSnapshot.id.toString()}',
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ]).show();
                                                  },
                                                  icon: Icon(
                                                      Icons.delivery_dining)),
                                              IconButton(
                                                  onPressed: () async {
                                                    Alert(
                                                        context: context,
                                                        desc:
                                                            'Did you deliver the order ?',
                                                        buttons: [
                                                          DialogButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                          DialogButton(
                                                            color:
                                                                Color.fromRGBO(
                                                                    243,
                                                                    73,
                                                                    73,
                                                                    1.0),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              Alert(
                                                                context:
                                                                    context,
                                                                desc:
                                                                    "Deliverd Successfuly",
                                                              ).show();
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'orders')
                                                                  .doc(documentSnapshot
                                                                      .id
                                                                      .toString())
                                                                  .set(
                                                                      {
                                                                    'status':
                                                                        'Deliverd',
                                                                  },
                                                                      SetOptions(
                                                                          merge:
                                                                              true));
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ]).show();
                                                  },
                                                  icon: Icon(Icons
                                                      .check_circle_outline_sharp))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${documentSnapshot['status']}',
                                style: TextStyle(
                                  color: documentSnapshot['status'] == 'Pending'
                                      ? Colors.orangeAccent
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
