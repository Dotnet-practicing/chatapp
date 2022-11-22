import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/auth/welcome_page.dart';
import 'package:timer/profile/profile_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (auth.currentUser == null) {
        Get.offAll(WelcomePage());
      } else {
        final db = FirebaseFirestore.instance;
        final collection = db.collection('users');
        final uid = auth.currentUser!.uid;
        final document = collection.doc(uid);

        document.get().then((value) {
          if (!value.exists) {
            Get.offAll(ProfileSetupScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
