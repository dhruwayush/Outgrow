import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/theme.dart';
import '../habits/provider/habits_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Patterns",
                style: GoogleFonts.merriweather(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Understand your triggers to outgrow them.",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),

              habitsAsync.when(
                data: (habits) {
                  if (habits.isEmpty) {
                    return const Center(child: Text("No data yet."));
                  }

                  // 1. Calculate Top Triggers
                  final Map<String, int> triggerCounts = {};
                  int totalSlips = 0;
                  
                  for (var habit in habits) {
                     for (var event in habit.slipEvents) {
                        totalSlips++;
                        final triggers = event.triggers.split(', ');
                        for (var t in triggers) {
                           if (t.isNotEmpty) {
                             triggerCounts[t] = (triggerCounts[t] ?? 0) + 1;
                           }
                        }
                     }
                  }

                  if (totalSlips == 0) {
                     return _EmptyState();
                  }

                  final sortedTriggers = triggerCounts.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  
                  final topTrigger = sortedTriggers.isNotEmpty ? sortedTriggers.first : null;

                  // 2. Calculate High Risk Time
                  final Map<String, int> timeBuckets = {
                    'Morning (6am-12pm)': 0,
                    'Afternoon (12pm-5pm)': 0,
                    'Evening (5pm-9pm)': 0,
                    'Night (9pm-6am)': 0,
                  };

                  for (var habit in habits) {
                    for (var event in habit.slipEvents) {
                      final hour = event.date.hour;
                      if (hour >= 6 && hour < 12) {
                        timeBuckets['Morning (6am-12pm)'] = (timeBuckets['Morning (6am-12pm)'] ?? 0) + 1;
                      } else if (hour >= 12 && hour < 17) {
                        timeBuckets['Afternoon (12pm-5pm)'] = (timeBuckets['Afternoon (12pm-5pm)'] ?? 0) + 1;
                      } else if (hour >= 17 && hour < 21) {
                         timeBuckets['Evening (5pm-9pm)'] = (timeBuckets['Evening (5pm-9pm)'] ?? 0) + 1;
                      } else {
                         timeBuckets['Night (9pm-6am)'] = (timeBuckets['Night (9pm-6am)'] ?? 0) + 1;
                      }
                    }
                  }
                  
                  final sortedTimes = timeBuckets.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final topTime = sortedTimes.isNotEmpty && sortedTimes.first.value > 0 ? sortedTimes.first : null;


                  return Column(
                    children: [
                      Row(
                        children: [
                          if (topTrigger != null)
                            Expanded(
                              child: _PatternCard(
                                title: "Top Trigger",
                                content: topTrigger.key,
                                subContent: "${topTrigger.value} slips",
                                icon: Icons.warning_amber_rounded,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          if (topTrigger != null && topTime != null)
                            const SizedBox(width: 12),
                          if (topTime != null)
                            Expanded(
                              child: _PatternCard(
                                title: "Risk Time",
                                content: topTime.key.split(' ').first, // Just 'Afternoon'
                                subContent: topTime.key.substring(topTime.key.indexOf('(')), // (12pm-5pm)
                                icon: Icons.access_time,
                                color: Colors.purpleAccent,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      _SectionHeader(title: "All Triggers"),
                      const SizedBox(height: 16),
                      ...sortedTriggers.map((e) => _TriggerRow(trigger: e.key, count: e.value, total: totalSlips)),

                      const SizedBox(height: 32),
                       _PatternCard(
                          title: "Wins vs Slips",
                          content: "You have ${habits.map((h) => h.checkInDates.length).fold(0, (a, b) => a + b)} clean days recorded.",
                          subContent: "Keep going.",
                          icon: Icons.emoji_events_outlined,
                          color: AppColors.primary,
                          fullWidth: true,
                        ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.query_stats, size: 48, color: AppColors.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            "No patterns yet.",
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 8),
           Text(
            "Track your habits and slips to see insights here.",
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String title;
  final String content;
  final String? subContent;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _PatternCard({
    required this.title, 
    required this.content, 
    this.subContent,
    required this.icon, 
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column( // changed Row to Column for better fit in grid, or logic to adapt
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.merriweather(
              fontSize: 16, // Smaller font if in grid
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          if (subContent != null) ...[
            const SizedBox(height: 4),
            Text(
              subContent!,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _TriggerRow extends StatelessWidget {
  final String trigger;
  final int count;
  final int total;

  const _TriggerRow({required this.trigger, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    final percentage = (count / total);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trigger, style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
              Text("$count times", style: GoogleFonts.manrope(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.warmBeige,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
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
        color: AppColors.textMuted,
      ),
    );
  }
}
