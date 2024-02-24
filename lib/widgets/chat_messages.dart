import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evminute/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (ctx, snaphot) {
        if (snaphot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snaphot.hasData || snaphot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Message Found'),
          );
        }
        if (snaphot.hasError || snaphot.data!.docs.isEmpty) {
          return const Center(
            child: Text('something went wrong...'),
          );
        }
        final loadedMessage = snaphot.data!.docs;
        return ListView.builder(
          itemCount: loadedMessage.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessage[index].data();
            final nextMessage = index + 1 < loadedMessage.length
                ? loadedMessage[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;
            final bool nextUserIsSame =
                nextMessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
