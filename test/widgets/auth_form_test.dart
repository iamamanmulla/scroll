import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll/src/features/auth/login_screen.dart';
import 'package:scroll/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Simple fake auth service for tests
class FakeAuthService implements AuthRepository {
  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  Future<UserCredential?> signInWithEmail(
    String email,
    String password,
  ) async => null;

  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) verificationCompleted,
    Function(FirebaseAuthException) verificationFailed,
    Function(String, int?) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  ) async {}

  @override
  Future<UserCredential> signInWithSmsCode(
    String verificationId,
    String smsCode,
  ) async => throw UnimplementedError();

  @override
  Future<void> signOut() async {}
}

final fakeAuth = FakeAuthService();

void main() {
  testWidgets('shows validation error for invalid email', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authService: fakeAuth)),
    );

    // Open the email/phone sheet
    expect(find.text('Use phone or email'), findsOneWidget);
    await tester.tap(find.text('Use phone or email'));
    await tester.pumpAndSettle();

    // Switch to the Email tab
    await tester.tap(find.text('Email / Username'));
    await tester.pumpAndSettle();

    // Enter invalid email and a password
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), 'not-an-email');
    await tester.enterText(fields.at(1), 'password123');

    // Attempt to submit
    await tester.tap(find.text('Log In'));
    await tester.pump();

    // Expect the inline validator message to appear
    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
