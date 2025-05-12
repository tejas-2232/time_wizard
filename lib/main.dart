import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/screens/home_screen.dart';
import 'package:timetrack/services/sheets_service.dart';
import 'package:timetrack/services/storage_service.dart';
import 'package:timetrack/services/timer_service.dart';
import 'package:timetrack/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final storageService = await StorageService.initialize();
  final sheetsService = SheetsService();
  final timerService = TimerService();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => storageService),
        ChangeNotifierProvider(create: (_) => sheetsService),
        ChangeNotifierProvider(create: (_) => timerService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}