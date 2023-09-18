import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restuarant/Screens/map.dart';
import '../Screens/home_Page.dart';
import '../Task/cart_data.dart';
import 'Screens/adminChatScreen.dart';
import 'Screens/chat_screen.dart';
import 'Screens/login.dart';
import 'Screens/order_tracking.dart';
import 'Screens/payment.dart';
import 'Screens/register.dart';
import 'Screens/splash_screen.dart';
import 'Screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restuarant_App',
        theme: ThemeData(

          backgroundColor: Colors.grey[50],
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          Welcome.id: (context) => Welcome(),
          Register.id: (context) => Register(),
          LoginPage.id: (context) => LoginPage(),
          HomePage.id: (context) => HomePage(),
          // OrderTrackingPage.id: (context) => OrderTrackingPage(),
          // OrderTracker.id: (context) => OrderTracker(),
          AdminChatScreen.id: (context) => AdminChatScreen(),
        },
      ),
    );
    
  }
}
