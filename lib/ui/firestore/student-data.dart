import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/utilities.dart';
import '../auth/login-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentData extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final String email;

  StudentData({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                auth.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return ['logout'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text('Logout'),
                );
              }).toList();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color(0xff26aecb),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
        title: Text('Student Data'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students') // Use 'students' collection
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final student = snapshot.data!.docs[0]; // Get the student document
            final data = student.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.only(top: 150),
              // child: Center(
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.blue[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, left: 10),
                  child: Column(
                    children: [
                      Text(
                        "Name: ${data['name']}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Email: ${data['email']}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Total Classes Held: ${data['classheld']}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Total Classes Taken: ${data['classtaken']}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Attendance Percentage: ${data['percentage']}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                    // ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "No student data found.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
