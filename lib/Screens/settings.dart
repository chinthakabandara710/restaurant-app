import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  var adminPassword;
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

  final TextEditingController oldpasswordController =
      new TextEditingController();
  final TextEditingController newpasswordController =
      new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              obscureText: _isObscure,
              controller: oldpasswordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Old Password',
                enabled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
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
            TextFormField(
              obscureText: _isObscure2,
              controller: newpasswordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    }),
                filled: true,
                fillColor: Colors.white,
                hintText: 'New Password',
                enabled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
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
            TextFormField(
              obscureText: _isObscure3,
              controller: confirmpassController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure3 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure3 = !_isObscure3;
                      });
                    }),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirm Password',
                enabled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 15.0),
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
                if (confirmpassController.text != oldpasswordController.text) {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    desc: "Password did not match",
                  ).show();
                  return "Password did not match";
                } else {
                  return null;
                }
              },
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    print('object');
                    if (adminPassword != oldpasswordController.text) {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        desc: "Old password is incorrect",
                      ).show();
                    } else if (confirmpassController.text !=
                        newpasswordController.text) {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        desc: "Enterd new password didn't match",
                      ).show();
                    } else {
                      String newPassword =
                          confirmpassController.text.toString();
                      final _productss =
                          FirebaseFirestore.instance.collection("appInfo");
                      await _productss
                          .doc('adminDetails')
                          .update({"password": newPassword});
                      Alert(
                        context: context,
                        type: AlertType.success,
                        desc: "Successfully Updated",
                      ).show();
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LoginPage(),
                    //   ),
                    // );
                  },
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
