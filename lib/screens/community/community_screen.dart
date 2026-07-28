import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/post.dart';
import '../../models/vote.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/vote_service.dart';
import '../../widgets/post_card.dart';
import '../post/create_post_screen.dart';
import '../post/post_detail_screen.dart';

/// Single-community view, e.g. everything posted under `m/gaming`.
class CommunityScreen extends StatefulWidget {
  final String communityId;

  const CommunityScreen({super.key, required this.communityId});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _firestoreService = FirestoreService();
  final _voteService = VoteService();
  final _authService = AuthService();

  Future<void> _vote(Post post, int value) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.communityPrefix + widget.communityId)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreatePostScreen(communityId: widget.communityId),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Post>>(
        stream: _firestoreService.watchFeed(communityId: widget.communityId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text('No posts here yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: PostCard(
                  post: post,
                  userVote: 0, // TODO: look up via VoteService
                  onUpvote: () => _vote(post, AppConstants.upvoteValue),
                  onDownvote: () => _vote(post, AppConstants.downvoteValue),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(postId: post.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
