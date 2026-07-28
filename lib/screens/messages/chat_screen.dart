import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/auth_service.dart';
import '../../services/message_service.dart';

/// One-on-one chat thread (feature 2).
class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String otherParticipantId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherParticipantId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageService = MessageService();
  final _authService = AuthService();
  final _textController = TextEditingController();

  Future<void> _send() async {
    final uid = _authService.currentUser?.uid;
    final body = _textController.text.trim();
    if (uid == null || body.isEmpty) return;

    await _messageService.sendMessage(
      conversationId: widget.conversationId,
      senderId: uid,
      body: body,
    );
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final myUid = _authService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherParticipantId)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageService.watchMessages(widget.conversationId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMine = message.senderId == myUid;
                    return Align(
                      alignment: isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(message.body),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
