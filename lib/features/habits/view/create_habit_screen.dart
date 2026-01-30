import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme.dart';
import '../provider/habits_provider.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _nameController = TextEditingController();
  String? _selectedCategory; // Nullable to insure selection triggers update
  
  final Map<String, IconData> _categories = {
    'smoking': Icons.smoke_free,
    'alcohol': Icons.local_drink,
    'sugar': Icons.icecream,
    'social_media': Icons.phonelink_off,
    'gaming': Icons.sports_esports,
    'shopping': Icons.shopping_bag,
    'junk_food': Icons.fastfood,
    'nail_biting': Icons.front_hand, // or do_not_touch
    'gambling': Icons.casino,
    'procrastination': Icons.timer_off,
    'late_night': Icons.bedtime,
    'other': Icons.check_circle_outline,
  };

  final Map<String, String> _categoryLabels = {
    'smoking': 'Smoking',
    'alcohol': 'Alcohol',
    'sugar': 'Sugar',
    'social_media': 'Social Media',
    'gaming': 'Gaming',
    'shopping': 'Shopping',
    'junk_food': 'Junk Food',
    'nail_biting': 'Nail Biting',
    'gambling': 'Gambling',
    'procrastination': 'Procrastination',
    'late_night': 'Late Night',
    'other': 'Other',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color ?? AppColors.textMain),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What are you trying to exit?",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nameController,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        decoration: InputDecoration(
                          hintText: "e.g. Late-night scrolling",
                          hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Suggestions",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _categories.entries.map((entry) {
                          final isSelected = _selectedCategory == entry.key;
                          return ChoiceChip(
                            label: Text(_categoryLabels[entry.key]!),
                            avatar: Icon(entry.value, size: 18, color: isSelected ? Colors.white : AppColors.primary),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = entry.key;
                                  // Auto-fill if empty OR if text matches another label (user switching mind)
                                  if (_nameController.text.isEmpty || _categoryLabels.values.contains(_nameController.text)) {
                                    _nameController.text = _categoryLabels[entry.key]!;
                                  }
                                });
                              }
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: Theme.of(context).cardColor,
                            labelStyle: TextStyle(
                              color: isSelected 
                                  ? Colors.white 
                                  : Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textMain,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(color: isSelected ? Colors.transparent : AppColors.primary.withOpacity(0.2)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24), // Extra padding at bottom of scroll
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  "Start Exit",
                  style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createHabit() {
    if (_nameController.text.isEmpty) return;
    
    ref.read(habitsProvider.notifier).addHabit(
      _nameController.text,
      _selectedCategory ?? 'other',
    );
    
    context.pop();
  }
}
