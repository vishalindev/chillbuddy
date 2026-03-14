import 'package:buddy_talk/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.record_voice_over_rounded, size: 72),
                const SizedBox(height: 18),
                const Text('Buddy Talk', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'Practice languages through live voice calls and podcast rooms.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                ElevatedButton.icon(
                  onPressed: auth.signingIn ? null : () => context.read<AuthProvider>().signInWithGoogle(),
                  icon: auth.signingIn
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(auth.signingIn ? 'Signing in...' : 'Continue with Google (OAuth2)'),
                ),
                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Text(auth.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
