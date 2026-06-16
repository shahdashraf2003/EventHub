import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Hub',
      theme: ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    surface: Colors.white,
  ),
  canvasColor: Colors.white,
),
       
      
      home: SplashScreen()
    );
  }
}