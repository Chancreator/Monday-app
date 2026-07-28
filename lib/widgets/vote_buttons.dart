import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Up/down arrows with the net score in between. [userVote] is 1, -1, or 0
/// (no vote yet) so the active arrow can be highlighted.
class VoteButtons extends StatelessWidget {
  final int score;
  final int userVote;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final Axis direction;

  const VoteButtons({
    super.key,
    required this.score,
    required this.userVote,
    required this.onUpvote,
    required this.onDownvote,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      IconButton(
        icon: Icon(
          Icons.arrow_upward,
          color: userVote == 1 ? AppTheme.upvoteColor : Colors.grey,
        ),
        onPressed: onUpvote,
        tooltip: 'Upvote',
      ),
      Text(
        '$score',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      IconButton(
        icon: Icon(
          Icons.arrow_downward,
          color: userVote == -1 ? AppTheme.downvoteColor : Colors.grey,
        ),
        onPressed: onDownvote,
        tooltip: 'Downvote',
      ),
    ];

    return direction == Axis.vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: children)
        : Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
