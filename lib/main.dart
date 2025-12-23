import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    // Initialize GoogleSignIn once after Firebase is ready. This is required
    // by google_sign_in >=7.0.0 (initialize must be called exactly once).
    try {
      // Provide the Web OAuth client ID (server client id) required on Android.
      // This value comes from the OAuth clients in android/app/google-services.json
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '76679517294-66a3k8telbjf0662asqq1qlqk6t24u9i.apps.googleusercontent.com',
      );
      // ignore: avoid_print
      print('GoogleSignIn initialized');
    } catch (e) {
      // ignore: avoid_print
      print('GoogleSignIn initialize error: $e');
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
