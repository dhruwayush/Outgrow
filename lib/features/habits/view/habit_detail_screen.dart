import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/theme.dart';
import '../provider/habits_provider.dart';
import '../model/habit.dart';

class HabitDetailScreen extends ConsumerWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              // TODO: Show edit/delete options
            },
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          final habit = habits.firstWhere(
            (h) => h.id == habitId,
            orElse: () => throw Exception('Habit not found'),
          );
          
          final isCleanDays = habit.checkInDates.length;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Flower Illustration
                    // Flower Illustration
                    Hero(
                      tag: 'flower_${habit.id}',
                      child: Container(
                        padding: const EdgeInsets.all(30), // Increased padding for larger glow area
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.primarySoft.withValues(alpha: 0.3) // Solid base tint
                              : Colors.white.withValues(alpha: 0.05),
                          gradient: RadialGradient(
                            colors: [
                              Theme.of(context).brightness == Brightness.light
                                  ? AppColors.primary.withValues(alpha: 0.15) // Stronger center
                                  : Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.7],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Lottie.asset(
                          'assets/animations/lotus_flower.json',
                          height: 220,
                          fit: BoxFit.contain,
                          // Optional: Check if we need to repeat or play once. Usually bloom is played once or looped breathing.
                          // Let's loop it gently if it's a loopable animation, or just play.
                          repeat: true, 
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleXY(
                        begin: 1.0,
                        end: 1.05,
                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "NO ${habit.category.toUpperCase().replaceAll('_', ' ')}",
                        style: GoogleFonts.manrope(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      "Your calm is blooming",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.merriweather(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headlineMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$isCleanDays days of nurturing yourself",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Stats Row
                    Row(
                      children: [
                        _StatCard(
                          label: "BEST STREAK",
                          value: "${habit.bestStreak}",
                          suffix: "days",
                          icon: Icons.emoji_events_outlined,
                        ),
                        const SizedBox(width: 16),
                        _StatCard(
                          label: "TOTAL CLEAN",
                          value: "$isCleanDays",
                          suffix: "/ 60", // Placeholder goal?
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Insight Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.primarySoft
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                                _getInsightMessage(habit),
                                style: GoogleFonts.manrope(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Calendar
                    _CalendarCard(habit: habit),
                    
                    const SizedBox(height: 32),
                    
                    // Urge Button
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.push('/urges'),
                        icon: const Icon(Icons.waves, color: AppColors.primary),
                        label: Text(
                          "I'm feeling an urge",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: AppColors.primarySoft,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
              
              // Floating Action Button
              // Floating Action Button
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: (() {
                  final now = DateTime.now();
                  final isCleanToday = habit.checkInDates.any(
                    (d) => d.year == now.year && d.month == now.month && d.day == now.day
                  );
                  final isSlipToday = habit.slipDates.any(
                    (d) => d.year == now.year && d.month == now.month && d.day == now.day
                  );

                  if (isCleanToday) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Avoided Today",
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (isSlipToday) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            "Slipped Today",
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ElevatedButton.icon(
                    onPressed: () {
                      _showCheckInOption(context, ref, habit);
                    },
                    icon: const Icon(Icons.check_circle, color: AppColors.textMain),
                    label: Text("Log Today", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF86EFAC),
                      foregroundColor: AppColors.textMain,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  );
                })(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCheckInOption(BuildContext context, WidgetRef ref, Habit habit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "How did it go today?",
              style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close sheet
                      context.push('/slip/${habit.id}'); // Navigate to Slip Screen
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      "I slipped",
                      style: GoogleFonts.manrope(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(habitsProvider.notifier).checkIn(habit.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF86EFAC),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      "I avoided it!",
                      style: GoogleFonts.manrope(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.suffix,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  ),
                ),
                Icon(icon, size: 18, color: AppColors.warmBeige.withValues(alpha: 1.0) /* using a beige icon tint */),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: GoogleFonts.merriweather(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  suffix,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final Habit habit;
  const _CalendarCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Reference interface shows "October 2023" header and S M T W T F S
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
         boxShadow: [
             BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: AppColors.textMuted),
              Text(
                DateFormat('MMMM yyyy').format(now),
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 24),
          _CalendarGrid(habit: habit),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final Habit habit;
  const _CalendarGrid({required this.habit});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    // Simple calendar logic: display current month
    // Need to find first day of month and days in month
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final startingWeekday = firstDay.weekday; // 1 = Mon, 7 = Sun. 
    // Reference starts with S (Sun). 
    // If startingWeekday is 1 (Mon), we need 1 offset if Sun is first.
    // Let's assume Mon start for simplicty or match generic. 
    // Image S M T W T F S => Sun start.
    
    // M T W T F S S
    List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    // We need to pad the beginning
    // If firstDay.weekday is 7 (Sun), pad 0.
    // If 1 (Mon), pad 1.
    // ...
    final padCount = firstDay.weekday % 7; 

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((d) => SizedBox(
            width: 30,
            child: Text(d, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12)),
          )).toList(),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8, // Tall for Dot below
          ),
          itemCount: daysInMonth + padCount,
          itemBuilder: (context, index) {
            if (index < padCount) return const SizedBox.shrink();
            
            final day = index - padCount + 1;
            final date = DateTime(now.year, now.month, day);
            final status = _getStatus(date);
            final isToday = date.day == now.day;
            final isSelected = day == 15; // Mock selection from image? No, just use Today logic.
            
            return Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: isToday ? const BoxDecoration(
                    color: AppColors.textMain,
                    shape: BoxShape.circle,
                  ) : null,
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: isToday ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Dot
                if (status != 0)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: status == 1 ? const Color(0xFF86EFAC) : Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  int _getStatus(DateTime date) {
    if (habit.checkInDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) return 1;
    if (habit.slipDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) return 2;
    return 0;
  }
}
  
String _getInsightMessage(Habit habit) {
  final now = DateTime.now();
  final currentMonth = DateUtils.dateOnly(DateTime(now.year, now.month, 1));
  final lastMonth = DateUtils.dateOnly(DateTime(now.year, now.month - 1, 1));

  // Calculate counts
  final thisMonthCount = habit.checkInDates.where((d) => 
    d.year == currentMonth.year && d.month == currentMonth.month
  ).length;

  final lastMonthCount = habit.checkInDates.where((d) => 
    d.year == lastMonth.year && d.month == lastMonth.month
  ).length;

  // Logic: If we have data for both months
  if (lastMonthCount > 0) {
    if (thisMonthCount > lastMonthCount) {
      final increase = ((thisMonthCount - lastMonthCount) / lastMonthCount * 100).round();
      return "You're doing gently. That's $increase% more peace than last month. Each day counts.";
    } else if (thisMonthCount == lastMonthCount) {
      return "You're maintaining your peace steadily. Consistency is the quietest form of growth.";
    } else {
      return "Every month is different. Be kind to yourself as you navigate the ebb and flow.";
    }
  }

  // Fallback Quotes if inadequate data (e.g., new habit or no last month data)
  final quotes = [
    "Small steps are still steps. You are moving forward.",
    "Be gentle with yourself. You are doing the best you can.",
    "Growth is a spiral process, doubling back on itself to reassess and regroup.",
    "Your direction is more important than your speed.",
    "Every moment is a new beginning. Reset breath, and begin again.",
  ];
  
  // Pick based on day of year to be consistent for the day, but rotate daily
  final quoteIndex = now.day % quotes.length;
  return quotes[quoteIndex];
}
