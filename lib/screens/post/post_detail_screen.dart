import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/comment.dart';
import '../../models/post.dart';
import '../../models/vote.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/vote_service.dart';
import '../../widgets/comment_tile.dart';
import '../../widgets/vote_buttons.dart';

/// Full post view: body, vote arrows, and the comment thread underneath —
/// covers the rest of feature 3 (board) and feature 4 (voting on comments).
class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _firestoreService = FirestoreService();
  final _voteService = VoteService();
  final _authService = AuthService();
  final _commentController = TextEditingController();

  Future<void> _votePost(Post post, int value) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await _voteService.castVote(
      userId: uid,
      targetId: post.id,
      targetType: VoteTargetType.post,
      targetCollectionPath: AppConstants.postsCollection,
      authorId: post.authorId,
      value: value,
    );
  }

  Future<void> _voteComment(Comment comment, int value) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    await _voteService.castVote(
      userId: uid,
      targetId: comment.id,
      targetType: VoteTargetType.comment,
      targetCollectionPath:
          '${AppConstants.postsCollection}/${comment.postId}/${AppConstants.commentsSubcollection}',
      authorId: comment.authorId,
      value: value,
    );
  }

  Future<void> _submitComment() async {
    final uid = _authService.currentUser?.uid;
    final body = _commentController.text.trim();
    if (uid == null || body.isEmpty) return;

    // TODO: replace placeholder username with the real profile lookup.
    await _firestoreService.addComment(
      postId: widget.postId,
      authorId: uid,
      authorUsername: 'you',
      body: body,
    );
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: FutureBuilder<Post?>(
        future: _firestoreService.fetchPost(widget.postId),
        builder: (context, postSnapshot) {
          if (!postSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final post = postSnapshot.data;
          if (post == null) {
            return const Center(child: Text('Post not found.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VoteButtons(
                          score: post.score,
                          userVote: 0, // TODO: look up current user's vote
                          onUpvote: () =>
                              _votePost(post, AppConstants.upvoteValue),
                          onDownvote: () =>
                              _votePost(post, AppConstants.downvoteValue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(post.body),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Text(
                      'Comments',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    StreamBuilder<List<Comment>>(
                      stream: _firestoreService.watchComments(widget.postId),
                      builder: (context, snapshot) {
                        final comments = snapshot.data ?? [];
                        if (comments.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('No comments yet.'),
                          );
                        }
                        return Column(
                          children: comments
                              .map((c) => CommentTile(
                                    comment: c,
                                    userVote: 0, // TODO: look up user's vote
                                    onUpvote: () => _voteComment(
                                        c, AppConstants.upvoteValue),
                                    onDownvote: () => _voteComment(
                                        c, AppConstants.downvoteValue),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _submitComment,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
