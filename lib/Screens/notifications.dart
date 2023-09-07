import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restuarant/Notifications/add_post.dart';
import '../constants.dart';

class Notifications extends StatelessWidget {
  bool? userType;
  String userid = '';
  String email = '';

  Notifications({Key? key, this.userType, this.userid = '', this.email = ''})
      : super(key: key) {
    _referencePosts = FirebaseFirestore.instance.collection('posts');
    // _future = _referencePosts.get();
  }
  late CollectionReference _referencePosts;
  late Future<QuerySnapshot> _future;

  final TextEditingController _msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offers'),
      ),
      floatingActionButton: Visibility(
        visible: userType == true ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddPost()));
          },
          child: Icon(Icons.add),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _referencePosts.orderBy('dateTime', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error:${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      late DocumentReference _documentReference;
                      late CollectionReference _referenceComments;
                      late Stream<QuerySnapshot> _streamComments;

                      _documentReference = FirebaseFirestore.instance
                          .collection('posts')
                          .doc(documentSnapshot.id);
                      _referenceComments =
                          _documentReference.collection('comments');
                      _streamComments = _referenceComments
                          .orderBy('posted_on', descending: true)
                          .snapshots();

                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: FractionallySizedBox(
                                heightFactor: 0.7,
                                child: Container(
                                  color: Color(0xff757575),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(30.0)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          // height: 500,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Comments',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30.0,
                                                      color: Colors.black
                                                          .withOpacity(0.8)),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Flexible(
                                                child: StreamBuilder(
                                                  stream: _referenceComments
                                                      .orderBy('posted_on',
                                                          descending: true)
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          streamSnapshot) {
                                                    if (streamSnapshot
                                                        .hasData) {
                                                      return ListView.builder(
                                                        itemCount:
                                                            streamSnapshot.data!
                                                                .docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final DocumentSnapshot
                                                              documentSnapshots =
                                                              streamSnapshot
                                                                  .data!
                                                                  .docs[index];

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: ListTile(
                                                              title: Text(
                                                                  '${documentSnapshots['comment_text']}'),
                                                              subtitle: Text(
                                                                  '${documentSnapshots['userEmail']}'),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                    return Text('Pending');
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextField(
                                                controller: _msgController,
                                                onChanged: (value) {
                                                  //Do something with the user input.
                                                },
                                                decoration:
                                                    kMessageTextFieldDecoration,
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.send,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () async {
                                                  final String? msg =
                                                      _msgController.text;
                                                  final String? userEmail =
                                                      email;

                                                  if (_msgController
                                                          .text.isNotEmpty &&
                                                      userEmail != null) {
                                                    // Persist a new product to Firestore
                                                    // CollectionReference _messages =
                                                    // FirebaseFirestore.instance.collection('messages').doc(loggedInUserId.toString());
                                                    await _referenceComments
                                                        .add({
                                                      "comment_text": msg,
                                                      "userEmail": userEmail,
                                                      "posted_on": FieldValue
                                                          .serverTimestamp(),
                                                    });

                                                    // Clear the text fields
                                                    _msgController.clear();
                                                  }
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black, spreadRadius: 2),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 3,
                                ),
                                child: Text(
                                  documentSnapshot['title'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            // height: 100,
                            // color: Colors.red,
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    documentSnapshot['imgUrl'],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      // bottomNavigationBar: bottom_app_bar(
      //   loggedInuserId: userid,
      //   loggedInEmail: email,
      //   user: userType,
      //   // fabLocation: FloatingActionButtonLocation.centerDocked,
      //   // shape: true ? const CircularNotchedRectangle() : null,
      // ),
    );
  }
}
