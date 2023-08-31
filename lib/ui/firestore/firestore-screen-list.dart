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
  final _formKey = GlobalKey<FormState>();

  final classesHeldController = TextEditingController();
  final classesTaken = TextEditingController();
  final editController = TextEditingController();
  final attendanceupdateController = TextEditingController();
  final firestore =
      FirebaseFirestore.instance.collection('students').snapshots();
  void updateAttendance() {
    int classestaken = int.tryParse(classesTaken.text) ?? 0;
    int classesHeld = int.tryParse(classesHeldController.text) ?? 0;
    if (classesTaken.text.contains('.') ||
        classesHeldController.text.contains('.')) {
      Utils().toastMessage(
          'Please enter whole numbers for classes taken and classes held');
      return;
    }

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

    attendanceupdateController.text = percentage.toStringAsFixed(2);
  }

  void verifyAttendance() {
    int classestaken = int.tryParse(classesTaken.text) ?? 0;
    int classesHeld = int.tryParse(classesHeldController.text) ?? 0;
    if (classesTaken.text.contains('.') ||
        classesHeldController.text.contains('.')) {
      Utils().toastMessage(
          'Please enter whole numbers for classes taken and classes held');
      return;
    }

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

    String attendance = percentage.toStringAsFixed(2);
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
              height: 400,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: editController,
                      decoration: InputDecoration(hintText: 'Edit here'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      controller: classesHeldController,
                      decoration: InputDecoration(hintText: 'Edit here'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field can not be empty';
                        }
                        int? intValue = int.tryParse(value);
                        if (intValue == null ||
                            intValue.toDouble() != double.parse(value)) {
                          return 'Classes taken can only be whole numbers';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      controller: classesTaken,
                      decoration: InputDecoration(hintText: 'Edit here'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field can not be empty';
                        }
                        int? intValue = int.tryParse(value);
                        if (intValue == null ||
                            intValue.toDouble() != double.parse(value)) {
                          return 'Classes taken can only be whole numbers';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
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
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
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
                        verifyAttendance();
                        if (_formKey.currentState!.validate() &&
                            attendance != attendanceupdateController.text) {
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
                            calculateClicked = false;
                          } catch (error) {
                            Utils().toastMessage(error.toString());
                          }
                        } else {
                          Utils().toastMessage("please update attendance");
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
                color: Colors.green,
              ),
            ),
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
                  color: Colors.grey,
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
