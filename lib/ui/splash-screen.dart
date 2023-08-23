import 'package:firebase/firebase-services/splash-services.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Splashservices splashScreen = Splashservices();
  @override
  void initState() {
    super.initState();
    splashScreen.islogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Firebase integration'),
    ));
  }
}
