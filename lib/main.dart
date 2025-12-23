import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scroll/firebase_options.dart';
import 'package:scroll/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // ignore: avoid_print
      print('Firebase initialized');
    } else {
      // ignore: avoid_print
      print('Firebase already initialized');
    }
  } on FirebaseException catch (e) {
    // Guard against race conditions or duplicate initialization calls
    if (e.code == 'duplicate-app') {
      // ignore: avoid_print
      print('Firebase already initialized (caught duplicate-app).');
    } else {
      rethrow;
    }
  } catch (e) {
    // ignore: avoid_print
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEA4359)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
