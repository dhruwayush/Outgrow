import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';
import '../../habits/provider/habits_provider.dart';

class SlipScreen extends ConsumerStatefulWidget {
  final String habitId;
  const SlipScreen({super.key, required this.habitId});

  @override
  ConsumerState<SlipScreen> createState() => _SlipScreenState();
}

class _SlipScreenState extends ConsumerState<SlipScreen> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _triggers = [
    'Stress', 'Boredom', 'Social pressure', 'Tired', 'Just felt like it'
  ];
  final Set<String> _selectedTriggers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMain),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Check-in",
          style: GoogleFonts.manrope(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(), // Skip acts as close for now
            child: Text(
              "Skip",
              style: GoogleFonts.manrope(
                color: const Color(0xFF4ADE80), // Green for Skip
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Leaf Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7), // Light green bg
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.spa, color: Color(0xFF16A34A), size: 40), // Darker green icon
              ),
              const SizedBox(height: 24),
              
              Text(
                "It happens.\nWhat triggered it?",
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Select a trigger to help understand\nthe pattern gently.",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Chips
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: _triggers.map((trigger) {
                  final isSelected = _selectedTriggers.contains(trigger);
                  return ChoiceChip(
                    label: Text(trigger),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                         if (selected) {
                          _selectedTriggers.add(trigger);
                        } else {
                          _selectedTriggers.remove(trigger);
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFDCFCE7), // Light green selection
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF4ADE80) : Colors.grey.withValues(alpha: 0.2),
                    ),
                    labelStyle: GoogleFonts.manrope(
                      color: isSelected ? const Color(0xFF166534) : AppColors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    showCheckmark: false,
                    avatar: isSelected ? const Icon(Icons.check, size: 18, color: Color(0xFF166534)) : null,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              
              // Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Anything you noticed?",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Text Field
              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "I noticed that around 4pm I felt...",
                  hintStyle: GoogleFonts.manrope(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 40),
              
              // Progress Valid
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Color(0xFF4ADE80), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Your progress is still valid.",
                    style: GoogleFonts.manrope(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Button
              ElevatedButton(
                onPressed: _submitSlip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E), // Vibrant Green
                  foregroundColor: Colors.white, // Text Color
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reset & Continue",
                      style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitSlip() async {
    final triggers = _selectedTriggers.join(', ');
    try {
      await ref.read(habitsProvider.notifier).slip(widget.habitId, triggers);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving slip: $e")),
        );
      }
    }
  }
}
