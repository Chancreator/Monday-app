import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../core/constants.dart';
import '../models/post.dart';
import 'vote_buttons.dart';

/// A single post preview shown in a feed. Tap to open [onTap] (post detail).
class PostCard extends StatelessWidget {
  final Post post;
  final int userVote;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.userVote,
    required this.onUpvote,
    required this.onDownvote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VoteButtons(
                score: post.score,
                userVote: userVote,
                onUpvote: onUpvote,
                onDownvote: onDownvote,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppConstants.communityPrefix}${post.communityId} '
                      '\u2022 u/${post.authorUsername} \u2022 '
                      '${timeago.format(post.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.comment_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text('${post.commentCount} comments'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
