import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/provider.dart';
import 'package:flutter_application_1/ui/bottomnav.dart';
import 'package:flutter_application_1/ui/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()),
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
      title: 'Campus Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      // home:  Splash(),
      home: BottomNav(),
    );
  }
}