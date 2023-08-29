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
                      // ... display other fields
                    ],
                    // ),
                  ),
                ),
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
