import 'package:flutter/material.dart';

class textFeild extends StatelessWidget {
  String? hint;
  textFeild({
    Key? key,
    required this.emailController,
    required this.hint,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        enabled: true,
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value!.length == 0) {
          return "$hint cannot be empty";
        }
        if (hint == 'Email') {
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please enter a valid email");
          } else {
            return null;
          }
        } else if (hint == 'Mobile Number') {
          if (!RegExp("[0-9]").hasMatch(value)) {
            return ("Please numbers only");
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      onChanged: (value) {},
      keyboardType: TextInputType.emailAddress,
    );
  }
}
