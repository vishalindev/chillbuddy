import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? currentUser;

  Future<void> signInWithGoogle() async {
    currentUser = await _googleSignIn.signIn();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    currentUser = null;
    notifyListeners();
  }
}
