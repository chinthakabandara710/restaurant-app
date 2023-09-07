import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restuarant/Screens/welcome.dart';
import '../constants.dart';
import 'adminChatScreen.dart';
import 'home_Page.dart';

class ChatScreen extends StatelessWidget {
  // static String id = "home_page";
  String userid = '';
  String email = '';

  ChatScreen(this.userid, this.email, {Key? key}) : super(key: key) {
    // _documentReference =
    //     FirebaseFirestore.instance.collection('users').doc(userid);
    // _referenceComments = _documentReference.collection('messages');
  }
  late DocumentReference _documentReference;
  late CollectionReference _referenceComments;

  @override
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? loggedInUser;
  // String? loggedInUserId;

  @override
  // void initState() {
  //   getDocs();
  //   route();
  //   // TODO: implement initState
  //   super.initState();
  //
  //   getCurrentUser();
  // }

  // void getDocs() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: loggedInUser)
  //       .get();
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //     // print(a['uid']);
  //     // setState(() {
  //     loggedInUserId = a['uid'].toString();
  //     // });
  //     // orderId = a['orderNumber'] + 1;
  //   }
  // }

  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser;
  //     if (user != null) {
  //       //do domething
  //       loggedInUser = user.email;
  //       print(loggedInUser);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('products');

  // void getMessages() async {
  //   // QuerySnapshot querySnapshot = await _collectionRef.get();
  //   // // Get data from docs and convert map to List
  //   // final allData = querySnapshot.docs.map((doc) => doc.data());
  //   // print(allData);
  //   await for (var snapshot
  //       in FirebaseFirestore.instance.collection('messages').snapshots()) {
  //     for (var messages in snapshot.docs) {
  //       // print(messages.data());
  //     }
  //   }
  //   ;
  // }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "admin") {
          role = true;
          // Navigator.pushNamed(context, HomePage.id);
        } else {
          role = false;
          // Navigator.pushNamed(context, ChatScreen.id);
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  bool? role;

  // text fields' controllers
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  // Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
  //   String action = 'create';
  //   if (documentSnapshot != null) {
  //     _msgController.text = documentSnapshot['msg'];
  //     _userEmailController.text = documentSnapshot['userEmail'];
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final _messages = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(loggedInUserId.toString());
    // final _userMessages = _messages.collection('messages');

    // getDocs();
    _documentReference =
        FirebaseFirestore.instance.collection('users').doc(userid);
    _referenceComments = _documentReference.collection('messages');
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                Navigator.pop(context);
              }),
        ],
        title: Text('Chat'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MessageStream(messages: _referenceComments, user: email),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: kMessageContainerDecoration,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _msgController,
                                onChanged: (value) {
                                  //Do something with the user input.
                                },
                                decoration: kMessageTextFieldDecoration,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                final String? msg = _msgController.text;
                                final String? userEmail = email;

                                if (_msgController.text.isNotEmpty &&
                                    userEmail != null) {
                                  // Persist a new product to Firestore
                                  // CollectionReference _messages =
                                  // FirebaseFirestore.instance.collection('messages').doc(loggedInUserId.toString());
                                  await _referenceComments.add({
                                    "msg": msg,
                                    "userEmail": userEmail,
                                    "timestamp": FieldValue.serverTimestamp(),
                                  });

                                  // Clear the text fields
                                  _msgController.clear();
                                  _userEmailController.clear();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Add new product
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key? key,
    required user,
    required CollectionReference<Object?> messages,
  })  : _messages = messages,
        user = user,
        super(key: key);

  final CollectionReference<Object?> _messages;
  final String user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messages.orderBy('timestamp', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final messageSender = documentSnapshot['userEmail'];
                final currentUser = user;
                return MessageBubble(
                  documentSnapshot: documentSnapshot,
                  isMe: messageSender == currentUser,
                );
              },
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.documentSnapshot,
    required this.isMe,
  }) : super(key: key);

  final DocumentSnapshot<Object?> documentSnapshot;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            documentSnapshot['userEmail'],
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.blueGrey : Colors.greenAccent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                documentSnapshot['msg'],
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          // Text(
          //   documentSnapshot['timestamp'].toString(),
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
        ],
      ),
    );
  }
}

// class MessageBubble extends StatelessWidget {
//   const MessageBubble({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           Text(documentSnapshot['msg']),
//           Material(
//             borderRadius: BorderRadius.circular(30.0),
//             elevation: 5.0,
//             color: Colors.blueAccent,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//               child: Text(
//                 documentSnapshot['msg'],
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
