import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/habits/model/habit.dart';
import 'features/habits/model/slip_event.dart';

import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(SlipEventAdapter());
  await Hive.openBox<Habit>('habits');
  await Hive.openBox('settings');
  
  // Notifications
  final notificationService = NotificationService();
  try {
    // Only init notifications if not on web, or handle web gracefully
    // Since we don't have kIsWeb imported here easily without adding it, let's rely on the service to handle it or just try/catch the whole block.
    // Ideally we import flutter/foundation.
    await notificationService.init();
    await notificationService.scheduleDailyNotification();
  } catch (e) {
    debugPrint("Notification Init Failed: $e");
  }

  runApp(const ProviderScope(child: OutgrowApp()));
}

class OutgrowApp extends ConsumerWidget {
  const OutgrowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: 'Habit Exit Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
