import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/message.dart';
import '../../services/auth_service.dart';
import '../../services/message_service.dart';
import 'chat_screen.dart';

/// List of the current user's DM threads (feature 2).
class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Not signed in.'));
    }

    return StreamBuilder<List<Conversation>>(
      stream: MessageService().watchConversationsFor(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final conversations = snapshot.data!;
        if (conversations.isEmpty) {
          return const Center(child: Text('No conversations yet.'));
        }
        return ListView.separated(
          itemCount: conversations.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            final otherParticipant = conversation.participantIds
                .firstWhere((id) => id != uid, orElse: () => 'unknown');
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(otherParticipant),
              subtitle: Text(
                conversation.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(timeago.format(conversation.updatedAt)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    conversationId: conversation.id,
                    otherParticipantId: otherParticipant,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
