import 'package:flutter/material.dart';

import '../models/community.dart';

/// A tappable chip showing an `m/community` name, used in lists and headers.
class CommunityChip extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;

  const CommunityChip({super.key, required this.community, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(community.displayName),
      onPressed: onTap,
    );
  }
}
