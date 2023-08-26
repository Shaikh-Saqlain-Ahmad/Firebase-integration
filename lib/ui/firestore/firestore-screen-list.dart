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
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firestore =
      FirebaseFirestore.instance.collection('students').snapshots();

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Edit here'),
            ),
          ),
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
                      .update({
                    'name': editController.text,
                  });
                  Utils().toastMessage('Updated');
                } catch (error) {
                  Utils().toastMessage(error.toString());
                }
              },
              child: Text('Update'),
            ),
          ],
        );
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
        title: Text('FireStore screen'),
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
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(snapshot.data!.docs[index]['name'].toString()),
                      onTap: () {
                        showMyDialog(
                          snapshot.data!.docs[index]['name'].toString(),
                          snapshot.data!.docs[index].id,
                        );
                      },
                      onLongPress: () {
                        showMyWarning(snapshot.data!.docs[index].id);
                      },
                    );
                  },
                ),
              );
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
