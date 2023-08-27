import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentData extends StatelessWidget {
  final String email;

  StudentData({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Data'),
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

            return Center(
              child: Column(
                children: [
                  Text("Name: ${data['name']}"),
                  Text("Email: ${data['email']}"),
                  Text("Total Classes Held: ${data['classheld']}"),
                  Text("Total Classes Taken: ${data['classtaken']}"),
                  Text("Attendance Percentage: ${data['percentage']}"),
                  // ... display other fields
                ],
              ),
            );
          } else {
            return Center(
              child: Text("No student data found."),
            );
          }
        },
      ),
    );
  }
}
