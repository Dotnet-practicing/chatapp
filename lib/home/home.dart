import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer/conversation_screen.dart';
import 'package:timer/find_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final chats = [].obs;
  final loading = true.obs;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final db = FirebaseFirestore.instance;
    final usersCol = db.collection('users');

    usersCol.doc(uid).collection('chats').snapshots().listen((event) async {
      for (var change in event.docChanges) {
        final user = await usersCol.doc(change.doc.id).get();
        chats.add({
          'id': change.doc.id,
          'name': user.data()?['name'] ?? 'Null',
          'lastMessage': change.doc.data()?['lastMessage'] ?? ''
        });
      }
      loading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChatApp')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(FindScreen());
        },
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (loading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else {
          return _buildList();
        }
      }),
    );
  }

  _buildList() {
    return Obx(() {
      if (chats.isEmpty) {
        return Center(child: Text('No Chats!'));
      } else {
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (ctx, index) {
            final chat = chats[index];
            final id = chat['id'];
            final lastMessage = chat['lastMessage'];

            return ListTile(
              onTap: () => Get.to(ConversationScreen(user: chat)),
              title: Text(chat['name']),
              subtitle: Text(lastMessage),
            );
          },
        );
      }
    });
  }
}
