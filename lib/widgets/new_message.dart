import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _MessageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _MessageController.dispose();
  }

  _sendMessage() {
    final enteredMessage = _MessageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    _MessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _MessageController,
            decoration: InputDecoration(labelText: 'Send a Message'),
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
          )),
          IconButton(
            onPressed: () {
              _sendMessage;
            },
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
