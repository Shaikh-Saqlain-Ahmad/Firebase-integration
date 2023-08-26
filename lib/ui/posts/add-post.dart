import 'package:firebase/utils/utilities.dart';
import 'package:firebase/widgets/round-button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLoading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Students');
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
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
                  databaseRef
                      .child(DateTime.now().microsecondsSinceEpoch.toString())
                      .set({
                    'id': DateTime.now().microsecondsSinceEpoch.toString(),
                    'Student name': postController.text
                  }).then((value) {
                    setState(() {
                      isLoading = false;
                    });
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
