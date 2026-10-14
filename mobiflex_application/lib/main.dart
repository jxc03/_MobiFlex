import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // PREPARE FLUTTER BEFORE WE USE A PLUGIN

  await Firebase.initializeApp(
    // SETS UP FIREBASE USING THE GENERATED CONFIGURATION + AWAIT- WAITS FOR SETUP TO FINISH BEFORE CALLING RUNAPP
    options:
        DefaultFirebaseOptions
            .currentPlatform, // SELECTS THE CONFIGURATION FOR WEB/ANDROID AUTOMA
  );

  runApp(const MyApp());
}

/// The root widget for MobiFlex.
class MyApp extends StatelessWidget {
  /// Creates the MobiFlex app.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobiFlex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
    );
  }
}
