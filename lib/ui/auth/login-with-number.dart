import 'package:firebase/ui/auth/verify-code.dart';
import 'package:firebase/utils/utilities.dart';
import 'package:firebase/widgets/round-button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final PhoneNumberController = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: PhoneNumberController,
            decoration: InputDecoration(hintText: '+92 1234567891'),
            //keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 80,
          ),
          RoundButton(
              title: 'login',
              loading: isLoading,
              ontap: () {
                setState(() {
                  isLoading = true;
                });
                auth.verifyPhoneNumber(
                    phoneNumber: PhoneNumberController.text,
                    verificationCompleted: (context) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        isLoading = false;
                      });
                      //e is exception
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCode(
                              verificationId:
                                  verificationId, //left wala verification is required instance of verify code and right wala jo code aa rha hai
                            ),
                          ));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        isLoading = false;
                      });
                      Utils().toastMessage(e.toString());
                    });
              })
        ]),
      ),
    );
  }
}
