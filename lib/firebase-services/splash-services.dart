import 'dart:async';

import 'package:firebase/ui/auth/login-screen.dart';
import 'package:firebase/ui/firestore/firestore-screen-list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashservices {
  void islogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      if (user.uid == '3CrTZlCZOLdkeIAZrgvR9AePRwX2') {
        Timer(
            const Duration(seconds: 5),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirestoreScreen(),
                )));
      } else {
        Timer(
            const Duration(seconds: 5),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                )));
      }
    } else {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              )));
    }
  }
}
