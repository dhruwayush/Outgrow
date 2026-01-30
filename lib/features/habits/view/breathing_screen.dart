import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _instructionText = "Breathe In";
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _startBreathingCycle();
  }
  
  void _startBreathingCycle() async {
    while (mounted) {
      // 1. Inhale (4s)
      setState(() => _instructionText = "Breathe In");
      await _controller.animateTo(1.0, duration: const Duration(seconds: 4));
      
      if (!mounted) break;

      // 2. Hold (7s)
      setState(() => _instructionText = "Hold");
      await Future.delayed(const Duration(seconds: 7));
      
      if (!mounted) break;

      // 3. Exhale (8s)
      setState(() => _instructionText = "Breathe Out");
      await _controller.animateTo(0.0, duration: const Duration(seconds: 8));
      
       if (!mounted) break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      body: Stack(
        children: [
          // Close button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textMain),
              onPressed: () => context.pop(),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _instructionText,
                    key: ValueKey(_instructionText),
                    style: GoogleFonts.merriweather(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Breathing Circle
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 200 * _scaleAnimation.value,
                      height: 200 * _scaleAnimation.value,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 150 * _scaleAnimation.value,
                          height: 150 * _scaleAnimation.value,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 80),
                
                 Text(
                  "Focus on your breath.",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
