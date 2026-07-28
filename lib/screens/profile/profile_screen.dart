import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';

/// Shows the signed-in user's ForgePoint total (feature 5) and basic info.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final uid = authService.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Not signed in.'));
    }

    return FutureBuilder<AppUser?>(
      future: authService.fetchUserProfile(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = snapshot.data;
        if (user == null) {
          return const Center(child: Text('Profile not found.'));
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 32, child: Text(user.username[0].toUpperCase())),
              const SizedBox(height: 12),
              Text(user.username, style: Theme.of(context).textTheme.titleLarge),
              Text(user.email, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: AppTheme.forgePointColor),
                      const SizedBox(width: 8),
                      Text(
                        '${user.forgePoints} ForgePoint',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              // TODO: add a tab/list here for the user's own posts and comments.
            ],
          ),
        );
      },
    );
  }
}
