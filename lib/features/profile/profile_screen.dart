import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/theme_provider.dart';
import '../habits/provider/habits_provider.dart';
import '../gamification/badges_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: GoogleFonts.merriweather(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 32),
              
              _SectionHeader(title: "Appearance"),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined, color: AppColors.textMain),
                      title: Text("Dark Mode", style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                      trailing: Switch(
                        value: themeMode == ThemeMode.dark,
                        activeTrackColor: AppColors.primary,
                        onChanged: (_) {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _SectionHeader(title: "Your Settlements"), // Achievements
              const SizedBox(height: 16),
              _BadgesGrid(),

              const SizedBox(height: 32),
              _SectionHeader(title: "Your Exit Habits"),
              const SizedBox(height: 16),
              
              habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) {
                     return Text(
                      "No active habits.",
                      style: GoogleFonts.manrope(color: AppColors.textMuted),
                     );
                  }
                  return Column(
                    children: habits.map((habit) => Container(
                       margin: const EdgeInsets.only(bottom: 12),
                       decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         title: Text(
                          habit.name, 
                          style: GoogleFonts.merriweather(fontWeight: FontWeight.bold)
                        ),
                        subtitle: Text(
                          "${habit.currentStreak} day streak",
                          style: GoogleFonts.manrope(color: AppColors.textMuted, fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                             _showDeleteConfirm(context, ref, habit.id, habit.name);
                          },
                        ),
                      ),
                    )).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
              ),

              const SizedBox(height: 48),
              
              Center(
                child: Column(
                  children: [
                    Text(
                      "Fall. Reset. Continue.",
                      style: GoogleFonts.patrickHand(
                        fontSize: 24,
                        color: AppColors.textMuted.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Outgrow v1.0.0",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.textMuted.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Nav bar padding
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref, String habitId, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Habit"),
        content: Text("Are you sure you want to delete '$name'? This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
             child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref.read(habitsProvider.notifier).deleteHabit(habitId);
              Navigator.pop(ctx);
            },
             child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: AppColors.textMain,
      ),
    );
  }
}

class _BadgesGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(badgesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate item width for 2 columns with 12px spacing
        // If width is infinite (unlikely in Column), default to something safe or 200
        double width = constraints.maxWidth;
        if (width.isInfinite) width = MediaQuery.of(context).size.width - 48;
        
        final itemWidth = (width - 12) / 2;

        return Wrap(
          runSpacing: 12,
          spacing: 12,
          children: allBadges.map((badge) {
            final isUnlocked = unlockedIds.contains(badge.id);
            return SizedBox(
              width: itemWidth,
              // height: 70, // Fixed height to ensure visibility? Let child determine.
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnlocked ? badge.color.withOpacity(0.3) : Colors.transparent,
                    width: 2,
                  ),
                   boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isUnlocked ? badge.color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badge.icon, 
                        color: isUnlocked ? badge.color : Colors.grey, 
                        size: 20
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            badge.name,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? AppColors.textMain : AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isUnlocked ? "Unlocked" : "Locked",
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              color: isUnlocked ? badge.color : AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }
    );
  }
}
