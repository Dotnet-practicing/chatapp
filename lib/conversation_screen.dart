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

    final senderUid = FirebaseAuth.instance.currentUser!.uid;
    final receiverUid = widget.user['id'];

    final db = FirebaseFirestore.instance;
    final usersCol = db.collection('users');

    // Sender chat
    final senderChatsCol = usersCol.doc(senderUid).collection('chats');
    final senderMessageDoc = senderChatsCol.doc(receiverUid);
    await senderMessageDoc.set({'lastMessage': message});
    await senderMessageDoc
        .collection('messages')
        .add({'message': message, 'sender': senderUid});
    // Receiver chat
    final receiverChatsCol = usersCol.doc(receiverUid).collection('chats');
    final receiverMessageDoc = receiverChatsCol.doc(senderUid);
    await receiverMessageDoc.set({'lastMessage': message});
    await receiverMessageDoc
        .collection('messages')
        .add({'message': message, 'sender': senderUid});
  }

  @override
  void initState() {
    super.initState();
    final sender = FirebaseAuth.instance.currentUser!.uid;
    final String receiver = widget.user['id'];

    final db = FirebaseFirestore.instance;
    final usersCol = db.collection('users');

    usersCol
        .doc(sender)
        .collection('chats')
        .doc(receiver)
        .collection('messages')
        .snapshots()
        .listen((event) {
      for (final changes in event.docChanges) {
        messages.insert(0, changes.doc.data());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [Text(widget.user['name'])],
      )),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (ctx, index) {
                  final message = messages[index];
                  return Column(
                    crossAxisAlignment: message['sender'] == FirebaseAuth.instance.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          message['message'],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  );
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
