import 'dart:async';

import 'package:firebase/ui/auth/login-screen.dart';
import 'package:flutter/material.dart';

class Splashservices {
  void islogin(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            )));
  }
}
