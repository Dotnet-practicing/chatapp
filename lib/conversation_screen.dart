import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required this.user}) : super(key: key);

  final Map user;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final messages = [].obs;

  final controller = TextEditingController();

  void sendMessage() async {
    final message = controller.text;
    messages.add(message);

    final sender = FirebaseAuth.instance.currentUser!.uid;
    final receiver = widget.user['id'];

    final db = FirebaseFirestore.instance;
    final usersCol = db.collection('users');
    await usersCol.doc(sender).collection('chats')
    .doc(receiver).collection('messages').add({
      'message': message
    });

    await usersCol.doc(receiver).collection('chats')
        .doc(sender).collection('messages').add({
      'message': message
    });
  }

  @override
  void initState() {
    super.initState();
    final sender = FirebaseAuth.instance.currentUser!.uid;
    final receiver = widget.user['id'];

    final db = FirebaseFirestore.instance;
    final usersCol = db.collection('users');
    usersCol.doc(sender).collection('chats').doc(receiver).collection('messages').snapshots().listen((event) {
      for (final doc in event.docs) {
        messages.add(doc.data()['message']);
      }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['id']),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (ctx, index) {

                  final message = messages[index];

                  return ListTile(title: Text(message));
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Enter messages'),
                  ),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: sendMessage,
                  mini: true,
                  elevation: 0,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
