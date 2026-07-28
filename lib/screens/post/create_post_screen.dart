import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class CreatePostScreen extends StatefulWidget {
  /// If a communityId is passed in (e.g. opened from within `m/gaming`),
  /// it's pre-filled and locked; otherwise the user types one in.
  final String? communityId;

  const CreatePostScreen({super.key, this.communityId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  late final TextEditingController _communityController =
      TextEditingController(text: widget.communityId ?? '');
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    final title = _titleController.text.trim();
    final communityId = _communityController.text.trim();
    if (title.isEmpty || communityId.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      // TODO: pull the real username from the user's Firestore profile
      // instead of a placeholder once profile caching is wired up.
      await _firestoreService.createPost(
        communityId: communityId,
        authorId: uid,
        authorUsername: 'you',
        title: title,
        body: _bodyController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New post')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _communityController,
              enabled: widget.communityId == null,
              decoration: const InputDecoration(
                prefixText: 'm/',
                labelText: 'Community',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
              maxLines: 6,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
