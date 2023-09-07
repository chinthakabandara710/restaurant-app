import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restuarant/Screens/home_Page.dart';
import 'package:restuarant/Screens/orders.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Task/cart_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

String? _character = "Card";

int? orderId;
final _auth = FirebaseAuth.instance;
String mobileNum = '12';

// final _getAppInfo = FirebaseFirestore.instance.collection('appInfo');

Future getDocs() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("appInfo").get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var a = querySnapshot.docs[i];
    print(a);
    orderId = a['orderNumber'] + 1;
  }
}

Future getMobileNum() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .where('uid', isEqualTo: _auth.currentUser?.uid.toString())
      .get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    var a = querySnapshot.docs[i];
    print(a['mobile']);
    mobileNum = a['mobile'].toString();
  }
}

void addPayment(context, total) {
  String? paymentId;
  final _paymentReference =
      FirebaseFirestore.instance.collection('payments').doc(paymentId);

  final _orders =
      FirebaseFirestore.instance.collection('orders').doc(orderId.toString());
  final _orderItems = _orders.collection('orderItems');

  print(_orders.id);

  paymentId = _paymentReference.id;
  // print(_paymentReference.id);

  var paymentDetails = {
    "amount": total,
    "payment_id": paymentId,
    "user_id": _auth.currentUser?.uid.toString(),
    "order_id": orderId,
    "payment_type": _character,
    "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    "time": DateFormat("HH:mm:ss").format(DateTime.now()),
  };

  var orderDetails = {
    "orderId": "paymentId",
    "user_id": _auth.currentUser?.uid.toString(),
    "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    "time": DateFormat("HH:mm:ss").format(DateTime.now()),
    "amount": total,
    "status": "Pending",
    "mobile": mobileNum,
  };

  _orders.set(orderDetails);

  // _paymentReference
  //     .set(myjsonobj)
  //     .then((value) => print("user with customid added"))
  //     .catchError((error) => print("failed to add user: $error"));

  int taskLength = Provider.of<CartData>(context, listen: false).cartItemCount;
  for (int i = 0; i < taskLength; i++) {
    final task = Provider.of<CartData>(context, listen: false).carts[i];
    Map<String, dynamic> commentToAdd = {
      'itemName': task.name,
      'itemPrice': task.price,
      'quantity': task.quantity,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "time": DateFormat("HH:mm:ss").format(DateTime.now()),
      'payment_id': paymentId,
      "user_id": _auth.currentUser?.uid.toString(),
    };
    _orderItems.add(commentToAdd);
  }
  _paymentReference.set(paymentDetails);
  Alert(
    context: context,
    type: AlertType.success,
    desc: "Successfully place the order",
    buttons: [
      DialogButton(
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Orders(),
            ),
          );
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
    ],
  ).show();
  Provider.of<CartData>(context, listen: false).emptyCart();

  updateOrderNumber();
  getDocs();
}

void updateOrderNumber() async {
  final _productss = FirebaseFirestore.instance.collection("appInfo");
  await _productss.doc('adminDetails').update({"orderNumber": orderId});
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    getMobileNum();
    getDocs();

    double total = Provider.of<CartData>(context, listen: false).getTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20.0),
                    child: Text(
                      'Select Your Payment Type',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Card Payment'),
                    leading: Radio<String>(
                      value: 'Card',
                      groupValue: _character,
                      onChanged: (String? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    trailing: Icon(
                      Icons.credit_card,
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: const Text('Cash Payment'),
                    leading: Radio<String>(
                      value: "Cash",
                      groupValue: _character,
                      onChanged: (String? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                    trailing: Icon(
                      Icons.money_sharp,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    'Total is : $total',
                    style: GoogleFonts.courgette(
                      // fontStyle: FontStyle.italic,
                      fontSize: 40,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // TextButton(
              //     onPressed: () {
              //       addPayment(context, total);
              //       var user = _auth.currentUser;
              //     },
              //     child: Text('Add')),
              Container(
                color: Colors.green,
                child: TextButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      desc: "Do you want to place the order?",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            addPayment(context, total);
                            var user = _auth.currentUser;
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                        DialogButton(
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                      ],
                    ).show();
                  },
                  child: Center(
                    child: Text(
                      'Place the order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
