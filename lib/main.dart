import 'package:event_hub/features/events/models/event_model.dart';
import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/features/events/presentation/screens/event_screen.dart';
import 'package:flutter/material.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
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
       
      
      home: EventsScreen()
    );
  }
}