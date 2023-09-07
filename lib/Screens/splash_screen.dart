import 'package:flutter/material.dart';
import 'package:restuarant/Screens/welcome.dart';

class SplashScreen extends StatefulWidget {
  static String id = "splash_screen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToScreen(BuildContext, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // child: Center(
      //   child: Icon(
      //     Icons.account_balance_outlined,
      //     size: 150,
      //     color: Colors.blue,
      //   ),
      child: Container(
        margin: EdgeInsets.all(120),
        height: 10,
        width: 10,
        child: Center(
          child: Image.asset(
            './assets/images/logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext, context) async {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Welcome()),
        ModalRoute.withName('welcome_screen'),
      );
      // Navigator.pushNamed(context, SplashScreen.id);
    });
  }
}
