import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evminute/firebaseCalls/firebase_operations.dart';
import 'package:evminute/models/UserModel.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  UserModel? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    userInfo = await FirebaseOperations().getUserInfo();
    if (mounted) {
      setState(() {}); // Trigger a rebuild to reflect the updated user info
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _sendMessage() async {
    final enteredMessage = _messageController.text.trim();
    if (enteredMessage.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    if (userInfo != null) {
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': userInfo!.firstName,
        'userImage': userInfo!.imageUrl,
      });
    } else {
      print('User data does not exist or is empty');
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
              decoration: InputDecoration(labelText: 'Send a Message'),
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
