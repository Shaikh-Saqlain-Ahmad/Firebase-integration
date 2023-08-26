import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/utils/utilities.dart';
import 'package:firebase/widgets/round-button.dart';
import 'package:firebase_database/firebase_database.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  bool isLoading = false;
  final postController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('students');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Firestore Data')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 2,
              decoration: InputDecoration(
                  hintText: 'Add', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: "Add",
                loading: isLoading,
                ontap: () {
                  setState(() {
                    isLoading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'name': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage('Student added');
                  }).onError((error, stackTrace) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
