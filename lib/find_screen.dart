import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/conversation_screen.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {

  final users = [].obs;

  void getAllUsers() async {
    final db = FirebaseFirestore.instance;
    final collection = db.collection('users');
    final results = await collection.get();

    final storage = FirebaseStorage.instance;

    for (final document in results.docs) {
      if (document.id == FirebaseAuth.instance.currentUser!.uid) {
        continue;
      }
      final user = {
        'id': document.id,
        'name': document.data()['name'],
        'picture': await storage.ref('users').child(document.id).getDownloadURL()
      };

      users.add(user);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Users')),
      body: Obx(() {
        if (users.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              final user = users[index];
              final name = user['name'] ?? '';
              final picture = user['picture'];

              return ListTile(
                onTap: () {
                  Get.to(ConversationScreen(user: user));
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(picture),
                ),
                title: Text(name),
              );
            },
          );
        }
      }),
    );
  }
}
