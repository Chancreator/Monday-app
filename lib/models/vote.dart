/// Records one user's vote on one target (a post or a comment).
///
/// One [Vote] document per (userId, targetId) pair — write it with a
/// deterministic id (e.g. `'${userId}_${targetId}'`) so a user can only
/// have one active vote per target; changing their mind updates [value]
/// instead of creating a second vote.
enum VoteTargetType { post, comment }

class Vote {
  final String id;
  final String userId;
  final String targetId;
  final VoteTargetType targetType;
  final int value; // 1 for upvote, -1 for downvote

  const Vote({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.value,
  });

  factory Vote.fromMap(String id, Map<String, dynamic> map) {
    return Vote(
      id: id,
      userId: map['userId'] as String? ?? '',
      targetId: map['targetId'] as String? ?? '',
      targetType: (map['targetType'] as String? ?? 'post') == 'post'
          ? VoteTargetType.post
          : VoteTargetType.comment,
      value: (map['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'targetId': targetId,
      'targetType': targetType.name,
      'value': value,
    };
  }
}
