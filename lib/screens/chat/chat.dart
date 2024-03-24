import 'package:evminute/widgets/chat_messages.dart';
import 'package:evminute/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static String routeName = "/chat_screen";
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages()),
          SizedBox(height: 20),
          NewMessages()
        ],
      ),
    );
  }
}
