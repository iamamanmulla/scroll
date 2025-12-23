import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll/services/auth_service.dart';

void main() {
  test('maps invalid-email to friendly message', () {
    final e = FirebaseAuthException(code: 'invalid-email', message: 'Bad');
    expect(
      AuthService.friendlyErrorMessage(e),
      'The email address is badly formatted.',
    );
  });

  test('maps user-not-found to friendly message', () {
    final e = FirebaseAuthException(code: 'user-not-found', message: 'No');
    expect(
      AuthService.friendlyErrorMessage(e),
      'No user found with that email.',
    );
  });

  test('maps wrong-password to friendly message', () {
    final e = FirebaseAuthException(code: 'wrong-password', message: 'No');
    expect(AuthService.friendlyErrorMessage(e), 'Incorrect password.');
  });

  test('falls back to exception message when unknown code', () {
    final e = FirebaseAuthException(code: 'some-other', message: 'Custom');
    expect(AuthService.friendlyErrorMessage(e), 'Custom');
  });

  test('falls back to generic message when no message', () {
    final e = FirebaseAuthException(code: 'some-other');
    expect(AuthService.friendlyErrorMessage(e), 'Authentication error');
  });
}
