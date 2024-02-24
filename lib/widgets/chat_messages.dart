import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (ctx, index) => Text(
            loadedMessage[index].data()['text'],
          ),
        );
      },
    );
  }
}
