import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/home.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({Key? key, required this.verificationId}) : super(key: key);

  final controller = TextEditingController();

  final String verificationId;

  void signIn() async {
    final auth = FirebaseAuth.instance;
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: controller.text,
    );

    try {
      await auth.signInWithCredential(credential);
      Get.offAll(HomeScreen());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: '######'
              ),
            ),

            SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                signIn();
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
