import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/comment.dart';
import '../models/community.dart';
import '../models/post.dart';

/// Reads and writes for communities, posts, and comments — the board
/// itself (feature 3) and the `m/` community structure (feature 6).
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---- Communities (feature 6) ----

  Future<Community> createCommunity({
    required String name,
    required String description,
  }) async {
    final doc = _db.collection(AppConstants.communitiesCollection).doc();
    final community = Community(
      id: doc.id,
      name: name,
      description: description,
      memberCount: 1,
      createdAt: DateTime.now(),
    );
    await doc.set(community.toMap());
    return community;
  }

  Stream<List<Community>> watchCommunities() {
    return _db
        .collection(AppConstants.communitiesCollection)
        .orderBy('memberCount', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Community.fromMap(d.id, d.data())).toList());
  }

  // ---- Posts (feature 3) ----

  Future<Post> createPost({
    required String communityId,
    required String authorId,
    required String authorUsername,
    required String title,
    required String body,
  }) async {
    final doc = _db.collection(AppConstants.postsCollection).doc();
    final post = Post(
      id: doc.id,
      communityId: communityId,
      authorId: authorId,
      authorUsername: authorUsername,
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    await doc.set(post.toMap());
    return post;
  }

  /// Feed ordered by net score (upvotes - downvotes) would need a computed
  /// field kept in sync by VoteService; for now this orders by recency.
  /// TODO: switch to score-based ranking once `netScore` field is populated.
  Stream<List<Post>> watchFeed({String? communityId}) {
    Query<Map<String, dynamic>> query =
        _db.collection(AppConstants.postsCollection);
    if (communityId != null) {
      query = query.where('communityId', isEqualTo: communityId);
    }
    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Post.fromMap(d.id, d.data())).toList());
  }

  Future<Post?> fetchPost(String postId) async {
    final doc =
        await _db.collection(AppConstants.postsCollection).doc(postId).get();
    if (!doc.exists) return null;
    return Post.fromMap(doc.id, doc.data()!);
  }

  // ---- Comments (feature 3) ----

  Future<Comment> addComment({
    required String postId,
    required String authorId,
    required String authorUsername,
    required String body,
  }) async {
    final postRef = _db.collection(AppConstants.postsCollection).doc(postId);
    final doc = postRef.collection(AppConstants.commentsSubcollection).doc();

    final comment = Comment(
      id: doc.id,
      postId: postId,
      authorId: authorId,
      authorUsername: authorUsername,
      body: body,
      createdAt: DateTime.now(),
    );

    await doc.set(comment.toMap());
    await postRef.update({'commentCount': FieldValue.increment(1)});

    return comment;
  }

  Stream<List<Comment>> watchComments(String postId) {
    return _db
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .collection(AppConstants.commentsSubcollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Comment.fromMap(d.id, d.data())).toList());
  }
}
