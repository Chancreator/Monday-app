import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../messages/conversations_screen.dart';
import '../post/create_post_screen.dart';
import '../profile/profile_screen.dart';
import 'feed_tab.dart';

/// Top-level shell: feed, messages, profile — the 3 tabs a signed-in user
/// moves between. Communities (feature 6) are reached from within the feed.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  final _authService = AuthService();

  static const _tabs = [
    FeedTab(),
    ConversationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MONDAY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => _authService.logout(),
          ),
        ],
      ),
      body: IndexedStack(index: _tabIndex, children: _tabs),
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.mail), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
