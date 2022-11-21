import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/request_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome To Chatapp', style: TextStyle(
              fontSize: 32
            ),),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Get.to(RequestScreen());
              },
              child: Text('Get Started'),
            )
          ],
        ),
      ),
    );
  }
}
