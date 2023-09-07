import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restuarant/Screens/map.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final CollectionReference orderList =
      FirebaseFirestore.instance.collection('orders');
  final _auth = FirebaseAuth.instance;
  var currentUser;

  var num;

  getUser() {
    currentUser = _auth.currentUser?.uid.toString();
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
                  return GestureDetector(
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
                                          itemCount:
                                              streamSnapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            final DocumentSnapshot
                                                documentSnapshot =
                                                streamSnapshot
                                                    .data!.docs[index];

                                            return Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(22.0),
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
                                                                FontWeight.bold,
                                                            fontSize: 20.0,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        ' ${documentSnapshot["quantity"]}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        ' ${documentSnapshot["itemPrice"]}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
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
                    child: Visibility(
                      visible: currentUser == documentSnapshot["user_id"] &&
                              (documentSnapshot['status'] == 'Pending' ||
                                  documentSnapshot['status'] == 'On the way')
                          ? true
                          : false,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    // margin: EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Order number : ${documentSnapshot.id}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => OrderTracker(
                                                      orderIdNum:
                                                          '${documentSnapshot.id.toString()}'),

                                                  // orderId: '${documentSnapshot.id.toString()}'
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.location_on_rounded,
                                              color: Colors.redAccent,
                                            ))
                                      ],
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
