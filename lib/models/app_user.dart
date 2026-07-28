/// A MONDAY user account.
///
/// [forgePoints] is the karma total described in feature 5: it goes up when
/// other users upvote this user's posts/comments, and down on downvotes.
class AppUser {
  final String uid;
  final String username;
  final String email;
  final int forgePoints;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.username,
    required this.email,
    this.forgePoints = 0,
    required this.createdAt,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      username: map['username'] as String? ?? 'unknown',
      email: map['email'] as String? ?? '',
      forgePoints: (map['forgePoints'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'forgePoints': forgePoints,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppUser copyWith({int? forgePoints}) {
    return AppUser(
      uid: uid,
      username: username,
      email: email,
      forgePoints: forgePoints ?? this.forgePoints,
      createdAt: createdAt,
    );
  }
}
