import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/vote.dart';

/// Handles upvote/downvote logic (feature 4) and keeps each author's
/// ForgePoint total (feature 5) in sync.
///
/// Design: one Vote document per (userId, targetId), keyed deterministically
/// so re-voting updates rather than duplicates. A Firestore transaction
/// keeps the post/comment's vote counts and the author's ForgePoint total
/// consistent even under concurrent votes.
class VoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _voteDocId(String userId, String targetId) => '${userId}_$targetId';

  /// Casts or changes a vote. [targetCollectionPath] is the posts or
  /// comments collection path the target document lives in, and
  /// [authorId] is who should receive/lose ForgePoint as a result.
  Future<void> castVote({
    required String userId,
    required String targetId,
    required VoteTargetType targetType,
    required String targetCollectionPath,
    required String authorId,
    required int value, // 1 = upvote, -1 = downvote
  }) async {
    final voteRef = _db
        .collection(AppConstants.votesCollection)
        .doc(_voteDocId(userId, targetId));
    final targetRef = _db.doc('$targetCollectionPath/$targetId');
    final authorRef =
        _db.collection(AppConstants.usersCollection).doc(authorId);

    await _db.runTransaction((tx) async {
      final existingVoteSnap = await tx.get(voteRef);
      final previousValue = existingVoteSnap.exists
          ? (existingVoteSnap.data()!['value'] as num).toInt()
          : 0;

      if (previousValue == value) {
        // Tapping the same vote again removes it (un-vote).
        tx.delete(voteRef);
        _applyDelta(tx, targetRef, authorRef, value, 0);
        return;
      }

      final vote = Vote(
        id: voteRef.id,
        userId: userId,
        targetId: targetId,
        targetType: targetType,
        value: value,
      );
      tx.set(voteRef, vote.toMap());
      _applyDelta(tx, targetRef, authorRef, previousValue, value);
    });
  }

  void _applyDelta(
    Transaction tx,
    DocumentReference targetRef,
    DocumentReference authorRef,
    int previousValue,
    int newValue,
  ) {
    final upvoteDelta =
        (newValue == 1 ? 1 : 0) - (previousValue == 1 ? 1 : 0);
    final downvoteDelta =
        (newValue == -1 ? 1 : 0) - (previousValue == -1 ? 1 : 0);
    final forgePointDelta = newValue - previousValue;

    tx.update(targetRef, {
      if (upvoteDelta != 0) 'upvotes': FieldValue.increment(upvoteDelta),
      if (downvoteDelta != 0) 'downvotes': FieldValue.increment(downvoteDelta),
    });
    tx.update(authorRef, {
      'forgePoints': FieldValue.increment(forgePointDelta),
    });
  }

  /// Looks up the current user's vote value (1, -1, or 0/none) on a target,
  /// so the UI can highlight the arrow they already tapped.
  Future<int> getUserVoteValue(String userId, String targetId) async {
    final doc =
        await _db.collection(AppConstants.votesCollection).doc(_voteDocId(userId, targetId)).get();
    if (!doc.exists) return 0;
    return (doc.data()!['value'] as num).toInt();
  }
}
