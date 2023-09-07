import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:restuarant/Screens/home_Page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdminPrivacy extends StatefulWidget {
  const AdminPrivacy({Key? key}) : super(key: key);

  @override
  State<AdminPrivacy> createState() => _AdminPrivacyState();
}

class _AdminPrivacyState extends State<AdminPrivacy> {
  var adminPassword;
  final TextEditingController _passwordController = TextEditingController();
  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("appInfo").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      adminPassword = a['password'];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getDocs();
    super.initState();
  }

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      child: TextField(
                        controller: _passwordController,
                        onChanged: (value) {
                          //Do something with the user input.
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Enter admin password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 44.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(colors: [
                          Colors.green,
                          Colors.green,
                          Colors.lightGreenAccent,
                        ]),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text == adminPassword) {
                            setState(() {
                              showSpinner == true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                            setState(() {
                              showSpinner == false;
                            });
                          } else {
                            Alert(
                              type: AlertType.warning,
                              context: context,
                              desc: "Incorrect Password",
                            ).show();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
