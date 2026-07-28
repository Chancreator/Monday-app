import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/comment.dart';
import 'vote_buttons.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final int userVote;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const CommentTile({
    super.key,
    required this.comment,
    required this.userVote,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoteButtons(
            score: comment.score,
            userVote: userVote,
            onUpvote: onUpvote,
            onDownvote: onDownvote,
            direction: Axis.horizontal,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'u/${comment.authorUsername} \u2022 '
                  '${timeago.format(comment.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(comment.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
