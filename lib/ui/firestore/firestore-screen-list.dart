import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/ui/auth/login-screen.dart';
import 'package:firebase/utils/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add-firestore.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  bool calculateClicked = false;
  final auth = FirebaseAuth.instance;

  final classesHeldController = TextEditingController();
  final classesTaken = TextEditingController();
  final editController = TextEditingController();
  final attendanceupdateController = TextEditingController();
  final firestore =
      FirebaseFirestore.instance.collection('students').snapshots();
  void updateAttendance() {
    int classestaken = int.tryParse(classesTaken.text) ?? 0;
    int classesHeld = int.tryParse(classesHeldController.text) ?? 0;
    double percentage = (classestaken / classesHeld) * 100;
    attendanceupdateController.text = percentage.toString();
  }

  Future<void> showMyDialog(String title, String id, String classheld,
      String classtaken, String attendance) async {
    editController.text = title;
    classesHeldController.text = classheld;
    classesTaken.text = classtaken;
    attendanceupdateController.text = attendance;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: Column(
                children: [
                  TextField(
                    controller: editController,
                    decoration: InputDecoration(hintText: 'Edit here'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: classesHeldController,
                    decoration: InputDecoration(hintText: 'Edit here'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: classesTaken,
                    decoration: InputDecoration(hintText: 'Edit here'),
                  ),
                  TextField(
                    controller: attendanceupdateController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                      icon: Icon(Icons.calculate),
                      onPressed: () {
                        updateAttendance();
                        setState(() {
                          calculateClicked = true;
                        });
                      },
                    )),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              calculateClicked
                  ? TextButton(
                      onPressed: () async {
                        try {
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection('students')
                              .doc(id)
                              .update({
                            'name': editController.text,
                            'classheld': classesHeldController.text,
                            'classtaken': classesTaken.text,
                            'percentage': attendanceupdateController.text,
                          });
                          Utils().toastMessage('Updated');
                        } catch (error) {
                          Utils().toastMessage(error.toString());
                        }
                      },
                      child: Text('Update'),
                    )
                  : Text(
                      'Update',
                      style: TextStyle(color: Colors.black),
                    )
            ],
          );
        });
      },
    );
  }

  Future<void> showMyWarning(String id) async {
    // editController.text = title;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this record'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection('students')
                      .doc(id)
                      .delete();
                  Utils().toastMessage('Deleted');
                } catch (error) {
                  Utils().toastMessage(error.toString());
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Students Record'),
        actions: [
          IconButton(
            onPressed: () {
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
            },
            icon: Icon(Icons.logout),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Encountered some error');
              }
              return Expanded(
                  child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey, // Customize the divider color here
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name'].toString()),
                    subtitle: Text(
                        snapshot.data!.docs[index]['percentage'].toString() +
                            '%'),
                    onTap: () {
                      showMyDialog(
                        snapshot.data!.docs[index]['name'].toString(),
                        snapshot.data!.docs[index].id,
                        snapshot.data!.docs[index]['classheld'].toString(),
                        snapshot.data!.docs[index]['classtaken'].toString(),
                        snapshot.data!.docs[index]['percentage'].toString(),
                      );
                    },
                    onLongPress: () {
                      showMyWarning(snapshot.data!.docs[index].id);
                    },
                  );
                },
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFirestoreData(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
