/// A post on a community board.
///
/// [upvotes] and [downvotes] are running counts kept in sync by
/// `VoteService` (feature 4). Net score = upvotes - downvotes.
class Post {
  final String id;
  final String communityId;
  final String authorId;
  final String authorUsername;
  final String title;
  final String body;
  final int upvotes;
  final int downvotes;
  final int commentCount;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.authorUsername,
    required this.title,
    required this.body,
    this.upvotes = 0,
    this.downvotes = 0,
    this.commentCount = 0,
    required this.createdAt,
  });

  int get score => upvotes - downvotes;

  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      communityId: map['communityId'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      authorUsername: map['authorUsername'] as String? ?? 'unknown',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      upvotes: (map['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (map['downvotes'] as num?)?.toInt() ?? 0,
      commentCount: (map['commentCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'communityId': communityId,
      'authorId': authorId,
      'authorUsername': authorUsername,
      'title': title,
      'body': body,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
