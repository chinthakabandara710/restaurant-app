import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:restuarant/Screens/home_Page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'AdminPrivacy.dart';

class LoginPage extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool visible = false;
  bool showSpinner = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green.shade400,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              './assets/images/restaurant2.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('./assets/images/logo.png'),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: 20.0, color: Colors.black),
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter your email',
                            // hintStyle: TextStyle(color: Colors.grey),
                            // enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              print("Email cannot be empty");
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter your password',
                            enabled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
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
                                setState(() {
                                  showSpinner = true;
                                  visible = true;
                                });
                                signIn(emailController.text,
                                    passwordController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          child: Container(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      try {
        final userEmail = await _auth.currentUser;
        if (userEmail != null) {
          //do domething
          loggedInUser = userEmail.email!;

          var role;

          User? user = await FirebaseAuth.instance.currentUser;
          var kk = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              if (documentSnapshot.get('role') == "admin") {
                role = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPrivacy(),
                  ),
                );
              } else {
                role = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              }
            } else {
              print('Document does not exist on the database');
            }
          });

          // role == true
          //     ? Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => AdminPrivacy(),
          //         ),
          //       )
          //     : Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => HomePage(),
          //         ),
          //       );
        }
      } catch (e) {
        Alert(
          type: AlertType.error,
          context: context,
          desc: e.toString(),
        ).show();
        print(e);
      }

      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Alert(
          type: AlertType.warning,
          context: context,
          desc: "No user found for that email.",
        ).show();
      } else if (e.code == 'wrong-password') {
        Alert(
          type: AlertType.error,
          context: context,
          desc: "Wrong password provided for that user.",
          // image: Image.asset(
          //     "./assets/success.png"),
        ).show();
      } else {
        Alert(
          type: AlertType.error,
          context: context,
          desc: e.code.toString(),
          // image: Image.asset(
          //     "./assets/success.png"),
        ).show();
        print(e.toString());
      }
    }
    setState(() {
      visible = false;
      showSpinner = false;
    });
  }

  void route() {}
}
