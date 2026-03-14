import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  GoogleSignInAccount? currentUser;
  bool signingIn = false;
  String? error;

  bool get isLoggedIn => currentUser != null;

  Future<void> signInWithGoogle() async {
    signingIn = true;
    error = null;
    notifyListeners();
    try {
      currentUser = await _googleSignIn.signIn();
      if (currentUser == null) {
        error = 'Sign-in cancelled by user.';
      }
    } catch (e) {
      error = 'Google OAuth login failed: $e';
    } finally {
      signingIn = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    currentUser = null;
    notifyListeners();
  }
}
