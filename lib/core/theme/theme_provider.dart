import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Load from Hive
    final box = Hive.box('settings');
    final String? savedMode = box.get('theme_mode');
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  void toggleTheme() {
    final box = Hive.box('settings');
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      box.put('theme_mode', 'dark');
    } else {
      state = ThemeMode.light;
      box.put('theme_mode', 'light');
    }
  }

  void setSystem() {
    state = ThemeMode.system;
    final box = Hive.box('settings');
    box.delete('theme_mode');
  }
}
