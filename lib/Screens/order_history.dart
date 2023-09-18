import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'order_tracking.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({Key? key}) : super(key: key);

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
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
        title: Text('Orders History'),
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
                    visible: (documentSnapshot['status'] == 'Deliverd')
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
                                              Text(
                                                'Amount : ${documentSnapshot['amount']}',
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ],
                                          ),
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
