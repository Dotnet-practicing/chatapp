import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timer/home/home.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final controller = TextEditingController();

  final selectedImage = ''.obs;

  void pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image?.path == null) {
      return;
    }

    selectedImage.value = image!.path;
  }

  void saveProfile() async {
    final name = controller.text;
    if (name.isEmpty || selectedImage.value.isEmpty) {
      return;
    }

    final picture = File(selectedImage.value);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    final collection = db.collection('users');
    final document = collection.doc(uid);
    await document.set({
      'name': name,
    });

    final storage = FirebaseStorage.instance;
    await storage.ref('users').child(uid).putFile(picture);


    Get.offAll(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            GestureDetector(
                onTap: () => pickImage(),
                child: Obx(() {
                  return CircleAvatar(
                    radius: 42,
                    backgroundImage: selectedImage.value.isNotEmpty
                        ? FileImage(File(selectedImage.value))
                        : null,
                    child: selectedImage.value.isEmpty
                        ? const Icon(Icons.person, size: 32)
                        : null,
                  );
                })),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Enter name'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => saveProfile(),
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
