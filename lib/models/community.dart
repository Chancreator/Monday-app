import '../core/constants.dart';

/// A topic community, e.g. `m/gaming`.
///
/// [name] is stored WITHOUT the `m/` prefix (just "gaming"); use [displayName]
/// wherever the prefix should show in the UI.
class Community {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final DateTime createdAt;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    this.memberCount = 0,
    required this.createdAt,
  });

  String get displayName => '${AppConstants.communityPrefix}$name';

  factory Community.fromMap(String id, Map<String, dynamic> map) {
    return Community(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      memberCount: (map['memberCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
