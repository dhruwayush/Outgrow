import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final box = Hive.box('settings');
    final bool onboarded = box.get('onboarding_seen', defaultValue: false);

    if (onboarded) {
      context.go('/');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.warmBeige,
              AppColors.primarySoft,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Outgrow",
                style: GoogleFonts.manrope(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOut),
              const SizedBox(height: 12),
              Text(
                "Track the days you didn't.",
                style: GoogleFonts.patrickHand(
                  fontSize: 20,
                  color: AppColors.textMuted,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
