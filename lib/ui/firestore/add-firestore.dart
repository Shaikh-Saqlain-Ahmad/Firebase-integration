import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/utils/utilities.dart';
import 'package:firebase/widgets/round-button.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final postController = TextEditingController();
  final emailController2 = TextEditingController();
  final classesHeldController = TextEditingController();
  final classesTaken = TextEditingController();
  final attendanceController = TextEditingController();

  final firestore = FirebaseFirestore.instance.collection('students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Student')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: postController,
                    maxLines: 2,
                    decoration: InputDecoration(
                        hintText: 'Enter Student name',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Student name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailController2,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter student Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    controller: classesHeldController,
                    decoration: InputDecoration(
                        hintText: 'Enter total classes held',
                        prefixIcon: Icon(Icons.numbers)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter classes held';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    controller: classesTaken,
                    decoration: InputDecoration(
                        hintText: 'Enter total classes taken',
                        prefixIcon: Icon(Icons.numbers)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter classes taken';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: attendanceController,
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: 'Click on icon for percentage',
                        suffixIcon: IconButton(
                          onPressed: () {
                            calculateAndDisplay();
                          },
                          icon: Icon(Icons.calculate),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter attendance';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                      title: "Add",
                      loading: isLoading,
                      ontap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          QuerySnapshot existingStudents = await firestore
                              .where('email',
                                  isEqualTo: emailController2.text.toString())
                              .get();

                          if (existingStudents.docs.isNotEmpty) {
                            Utils().toastMessage(
                                'A student with the same email already exists');
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          String id =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          firestore.doc(id).set({
                            'name': postController.text.toString(),
                            'id': id,
                            'email': emailController2.text.toString(),
                            'classheld': classesHeldController.text.toString(),
                            'classtaken': classesTaken.text.toString(),
                            'percentage': attendanceController.text.toString(),
                          }).then((value) {
                            setState(() {
                              isLoading = false;
                              postController.clear();
                              emailController2.clear();
                              classesHeldController.clear();
                              classesTaken.clear();
                              attendanceController.clear();
                            });
                            Utils().toastMessage('Student added');
                          }).onError((error, stackTrace) {
                            setState(() {
                              isLoading = false;
                            });
                            Utils().toastMessage(error.toString());
                          });
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void calculateAndDisplay() {
    int classestaken = int.tryParse(classesTaken.text) ?? 0;
    int classesHeld = int.tryParse(classesHeldController.text) ?? 0;

    if (classesHeld == 0) {
      Utils().toastMessage('Total classes held cannot be 0');
      return;
    }

    double percentage = (classestaken / classesHeld) * 100;

    if (percentage < 0) {
      Utils().toastMessage('Percentage cannot be negative');
      return;
    } else if (percentage > 100) {
      Utils().toastMessage('Percentage cannot be greater than 100');
      return;
    }

    attendanceController.text = percentage.toStringAsFixed(2);
  }
}
