import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewMessage();
  }
}

class _NewMessage extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    print('Message entered: $enteredMessage');
    if (enteredMessage.trim().isEmpty) {
      print('Message is empty');
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    print('Message cleared');

    try {
      // Send to Firebase
      final user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      print('User data retrieved: ${userData.data()}');

      FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('messages')
          .add({
        'text': enteredMessage,
        'createAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['image_url'],
      });

      print('Message sent');
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.none,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send a message..',
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              print('IconButton pressed');
              _submitMessage();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
