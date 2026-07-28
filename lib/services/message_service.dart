import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/message.dart';

/// Handles private conversations and messages (feature 2).
class MessageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Finds an existing 1:1 conversation between two users, or creates one.
  Future<Conversation> getOrCreateConversation({
    required String userAId,
    required String userBId,
  }) async {
    final existing = await _db
        .collection(AppConstants.conversationsCollection)
        .where('participantIds', arrayContains: userAId)
        .get();

    for (final doc in existing.docs) {
      final ids = List<String>.from(doc.data()['participantIds'] as List);
      if (ids.contains(userBId)) {
        return Conversation.fromMap(doc.id, doc.data());
      }
    }

    final doc = _db.collection(AppConstants.conversationsCollection).doc();
    final conversation = Conversation(
      id: doc.id,
      participantIds: [userAId, userBId],
      updatedAt: DateTime.now(),
    );
    await doc.set(conversation.toMap());
    return conversation;
  }

  Stream<List<Conversation>> watchConversationsFor(String userId) {
    return _db
        .collection(AppConstants.conversationsCollection)
        .where('participantIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Conversation.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
  }) async {
    final convoRef = _db
        .collection(AppConstants.conversationsCollection)
        .doc(conversationId);
    final messageRef =
        convoRef.collection(AppConstants.messagesSubcollection).doc();

    final message = Message(
      id: messageRef.id,
      conversationId: conversationId,
      senderId: senderId,
      body: body,
      sentAt: DateTime.now(),
    );

    await messageRef.set(message.toMap());
    await convoRef.update({
      'lastMessage': body,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Message>> watchMessages(String conversationId) {
    return _db
        .collection(AppConstants.conversationsCollection)
        .doc(conversationId)
        .collection(AppConstants.messagesSubcollection)
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Message.fromMap(d.id, d.data())).toList());
  }
}
