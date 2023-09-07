import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String loggedInUser = '';

class AdminChatScreen extends StatefulWidget {
  static String id = 'admin_chat_screen';
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        //do domething
        loggedInUser = user.email!;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final _messages = FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "user");
    // final _userMessages = _messages.collection('messages');

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin chat'),
      ),
      body: StreamBuilder(
        stream: _messages.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      // final _userMessages = _messages
                      //     .doc(documentSnapshot.id.toString())
                      //     .collection('messages');
                      // final FirebaseAuth _auth = FirebaseAuth.instance;
                      // String? loggedUser = _auth.currentUser.email;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(documentSnapshot.id, loggedInUser),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 5,
                            // margin: EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    documentSnapshot['firstname'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    documentSnapshot['lastname'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
