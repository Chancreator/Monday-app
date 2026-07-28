/// App-wide constants for MONDAY.
class AppConstants {
  AppConstants._();

  static const String appName = 'MONDAY';
  static const String communityPrefix = 'm/';

  // Firestore collection names — keep in one place so a rename is one edit.
  static const String usersCollection = 'users';
  static const String communitiesCollection = 'communities';
  static const String postsCollection = 'posts';
  static const String commentsSubcollection = 'comments';
  static const String votesCollection = 'votes';
  static const String conversationsCollection = 'conversations';
  static const String messagesSubcollection = 'messages';

  // Voting
  static const int upvoteValue = 1;
  static const int downvoteValue = -1;
}
