import 'package:flutter/material.dart';

import '../../models/community.dart';
import '../../models/post.dart';
import '../../models/vote.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/vote_service.dart';
import '../../core/constants.dart';
import '../../widgets/community_chip.dart';
import '../../widgets/post_card.dart';
import '../community/community_screen.dart';
import '../community/create_community_screen.dart';
import '../post/post_detail_screen.dart';

/// The main board (feature 3): a scrollable list of communities to jump
/// into, plus a global feed of posts across all communities.
class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _CommunityStrip(onCreate: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateCommunityScreen(),
                ),
              )),
        ),
        StreamBuilder<List<Post>>(
          stream: _firestoreService.watchFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final posts = snapshot.data!;
            if (posts.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text('No posts yet. Be the first!')),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: PostCard(
                      post: post,
                      userVote: 0, // TODO: look up via VoteService per post
                      onUpvote: () => _vote(post, AppConstants.upvoteValue),
                      onDownvote: () =>
                          _vote(post, AppConstants.downvoteValue),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PostDetailScreen(postId: post.id),
                        ),
                      ),
                    ),
                  );
                },
                childCount: posts.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CommunityStrip extends StatelessWidget {
  final VoidCallback onCreate;

  const _CommunityStrip({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: StreamBuilder<List<Community>>(
        stream: FirestoreService().watchCommunities(),
        builder: (context, snapshot) {
          final communities = snapshot.data ?? [];
          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('New community'),
                onPressed: onCreate,
              ),
              const SizedBox(width: 8),
              for (final community in communities) ...[
                CommunityChip(
                  community: community,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CommunityScreen(communityId: community.id),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          );
        },
      ),
    );
  }
}
