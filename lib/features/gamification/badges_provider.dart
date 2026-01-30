import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const Badge({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.icon,
    required this.color,
  });
}

final List<Badge> allBadges = [
  Badge(
    id: 'first_step',
    name: 'First Step',
    description: 'Completed your first clean day.',
    icon: Icons.directions_walk,
    color: Colors.green,
  ),
  Badge(
    id: 'week_warrior',
    name: 'Week Warrior',
    description: 'Achieved a 7-day streak.',
    icon: Icons.local_fire_department,
    color: Colors.orange,
  ),
  Badge(
    id: 'urge_surfer',
    name: 'Urge Surfer',
    description: 'Chose a replacement instead of slipping.',
    icon: Icons.surfing,
    color: Colors.blue,
  ),
  Badge(
    id: 'honest_tracker',
    name: 'Honest Tracker',
    description: 'Logged a slip. Honesty helps growth.',
    icon: Icons.favorite,
    color: Colors.pinkAccent,
  ),
];

// Using Notifier (Riverpod 2.0)
class BadgesNotifier extends Notifier<List<String>> {
  late Box _box;

  @override
  List<String> build() {
    _box = Hive.box('settings');
    return List<String>.from(_box.get('unlocked_badges', defaultValue: <String>[]));
  }

  Future<void> unlock(String badgeId) async {
    if (!state.contains(badgeId)) {
      final newState = [...state, badgeId];
      state = newState;
      await _box.put('unlocked_badges', newState);
    }
  }
  
  bool isUnlocked(String badgeId) => state.contains(badgeId);
}

final badgesProvider = NotifierProvider<BadgesNotifier, List<String>>(BadgesNotifier.new);
