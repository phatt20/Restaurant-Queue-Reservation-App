import 'package:chat/screens/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages found'));
        }

        List<Future<QuerySnapshot<Map<String, dynamic>>>> messageFutures = [];

        for (var userDoc in userSnapshot.data!.docs) {
          messageFutures.add(
            FirebaseFirestore.instance
                .collection('user')
                .doc(userDoc.id)
                .collection('messages')
                .orderBy('createAt', descending: true)
                .get(),
          );
        }

        return FutureBuilder(
          future: Future.wait(messageFutures),
          builder: (ctx, messagesSnapshot) {
            if (messagesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!messagesSnapshot.hasData || messagesSnapshot.data!.isEmpty) {
              return const Center(child: Text('No messages found'));
            }

            // รวมทุกข้อความจากทุก users และเรียงตาม createAt
            List<Map<String, dynamic>> allMessages = [];

            for (var snapshot in messagesSnapshot.data!) {
              for (var doc in snapshot.docs) {
                allMessages.add(doc.data());
              }
            }

            allMessages.sort((a, b) => (b['createAt'] as Timestamp)
                .compareTo(a['createAt'] as Timestamp));

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
              reverse: true,
              itemCount: allMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = allMessages[index];
                final nextChatMessage = index + 1 < allMessages.length
                    ? allMessages[index + 1]
                    : null;

                final currentMessageUserId = chatMessage['userId'];
                final nextChatMessageUserId = nextChatMessage?['userId'];

                final nextUserIsSame =
                    nextChatMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                } else {
                  return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
