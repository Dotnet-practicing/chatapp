import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final users = [].obs;

  void getAllUsers() async {
    final db = FirebaseFirestore.instance;
    final collection = db.collection('users');
    final results = await collection.get();

    final storage =  FirebaseStorage.instance;

    print(results.size);

    for (final document in results.docs) {
      final user = {
        'name': document.data()['name'],
        'picture' : await storage.ref('users').child(document.id).getDownloadURL()
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
      appBar: AppBar(title: Text('ChatApp')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (users.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {

              final user = users[index];
              final name = user['name'];
              final picture = user['picture'];

              return ListTile(
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
