/// A single direct message inside a [Conversation] (feature 2).
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String body;
  final DateTime sentAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    required this.sentAt,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      conversationId: map['conversationId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      body: map['body'] as String? ?? '',
      sentAt: DateTime.tryParse(map['sentAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'body': body,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}

/// A private conversation between exactly two users (extendable to group DMs
/// later by allowing more than two [participantIds]).
class Conversation {
  final String id;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.participantIds,
    this.lastMessage = '',
    required this.updatedAt,
  });

  factory Conversation.fromMap(String id, Map<String, dynamic> map) {
    return Conversation(
      id: id,
      participantIds: List<String>.from(map['participantIds'] as List? ?? []),
      lastMessage: map['lastMessage'] as String? ?? '',
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
