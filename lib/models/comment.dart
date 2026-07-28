/// A comment on a post. Comments are votable, same as posts (feature 4).
class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorUsername;
  final String body;
  final int upvotes;
  final int downvotes;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorUsername,
    required this.body,
    this.upvotes = 0,
    this.downvotes = 0,
    required this.createdAt,
  });

  int get score => upvotes - downvotes;

  factory Comment.fromMap(String id, Map<String, dynamic> map) {
    return Comment(
      id: id,
      postId: map['postId'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      authorUsername: map['authorUsername'] as String? ?? 'unknown',
      body: map['body'] as String? ?? '',
      upvotes: (map['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (map['downvotes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorUsername': authorUsername,
      'body': body,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
