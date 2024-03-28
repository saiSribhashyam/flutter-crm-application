import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'addcustomer.dart';
import 'firebase_options.dart';

void main()  async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyCvFgQ8Uqs7gecuDLD2jpXD2mEUVoQ33fo", appId: "1:677267039930:android:124745fa1fc730270d0483", messagingSenderId: "677267039930", projectId: "shopmitra-4f135")
);

  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signnup': (context) => SignupPage(),
        '/home': (context) => HomeScreen(),
        '/addcustomer':(context)=> AddCustomer(),
      },
    );
  }
}
