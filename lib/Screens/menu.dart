import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restuarant/Screens/auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Task/cart_data.dart';
import './add_item.dart';

class MenuScreen extends StatelessWidget {
  String id = '';
  String imgUrl = '';
  bool? role;

  MenuScreen(this.id, this.imgUrl, this.role, {Key? key}) : super(key: key) {
    _documentReference = FirebaseFirestore.instance.collection('Menu').doc(id);
    _referenceComments = _documentReference.collection('subMenu');
  }
  late DocumentReference _documentReference;
  late CollectionReference _referenceComments;

  @override
  Widget build(BuildContext context) {
    Future<void> _deleteProduct(String productId) async {
      await _referenceComments.doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have successfully deleted a item'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: 600,
            left: 10,
            right: 10,
          ),
        ),
      );
    }

    String? newTaskTitle;
    double newPriceVal = 100.0;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Menu'),
      // ),
      body: Column(
        children: [
          Container(
            // width: double.infinity,
            height: 250.0,
            // color: Colors.greenAccent,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("$imgUrl"), fit: BoxFit.cover),
            ),
          ),
          Flexible(
            child: StreamBuilder(
              stream: _referenceComments
                  .orderBy('price', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Container(
                        // margin: const EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              '${documentSnapshot['image'].toString()}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            documentSnapshot['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            'Rs. ' + documentSnapshot['price'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Press this button to edit a single product
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    int newQuantity = 1;
                                    newTaskTitle =
                                        documentSnapshot['name'].toString();
                                    String PriceVal =
                                        documentSnapshot['price'].toString();
                                    newPriceVal = double.parse(PriceVal);
                                    Provider.of<CartData>(context,
                                            listen: false)
                                        .addItems(newTaskTitle, newPriceVal,
                                            newQuantity);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text('Added to the cart'),
                                    //     behavior: SnackBarBehavior.floating,
                                    //     backgroundColor: Colors.teal,
                                    //     margin: EdgeInsets.only(
                                    //       bottom: 600,
                                    //       left: 10,
                                    //       right: 10,
                                    //     ),
                                    //   ),
                                    // );
                                    Fluttertoast.showToast(
                                        msg: 'Added to the cart');
                                  },
                                ),
                                Visibility(
                                  visible: role == true ? true : false,
                                  child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        Alert(
                                            context: context,
                                            desc: 'Do you want to delete ',
                                            buttons: [
                                              DialogButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              DialogButton(
                                                color: Color.fromRGBO(
                                                    243, 73, 73, 1.0),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deleteProduct(
                                                      documentSnapshot.id);

                                                  Alert(
                                                    context: context,
                                                    desc:
                                                        "Successfully deleted.",
                                                    // image: Image.asset(
                                                    //     "./assets/success.png"),
                                                  ).show();
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ]).show();
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {}

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
      floatingActionButton: Visibility(
        visible: role == true ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddItem(id)));
          },
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
