import 'package:firebase/ui/posts/post-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/utilities.dart';
import '../../widgets/round-button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  @override
  final OTPcontroller = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: OTPcontroller,
            decoration: InputDecoration(hintText: '+92 1234567891'),
            //keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 80,
          ),
          RoundButton(
            title: 'Verify',
            loading: isLoading,
            ontap: () async {
              setState(() {
                isLoading = true;
              });
              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: OTPcontroller.toString());
              try {
                await auth.signInWithCredential(credential);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Post(),
                    ));
              } catch (e) {
                setState(() {
                  isLoading = false;
                  Utils().toastMessage(e.toString());
                });
              }
            },
          )
        ]),
      ),
    );
  }
}
