import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/auth/verifaction_screen.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen({Key? key}) : super(key: key);

  final controller = TextEditingController();

  final loading = false.obs;

  void verifyPhoneNumber() {
    loading.value = true;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: controller.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException ex) {
        print(ex);
      },
      codeSent: (String verificationId, int? resendToken) {
        print('code sent');
        Get.to(VerificationScreen(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Obx(() {
              return TextField(
                enabled: loading.isFalse,
                controller: controller,
                decoration: InputDecoration(hintText: 'Phone Number'),
              );
            }),
            SizedBox(height: 32),
            Obx(() {
              return ElevatedButton(
                onPressed: loading.isTrue ? null : () {
                  verifyPhoneNumber();
                },
                child: loading.isTrue
                    ? CircularProgressIndicator()
                    : Text('Next'),
              );
            })
          ],
        ),
      ),
    );
  }
}
