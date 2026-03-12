import 'package:buddy_talk/core/theme/app_theme.dart';
import 'package:buddy_talk/features/auth/presentation/providers/auth_provider.dart';
import 'package:buddy_talk/features/call/presentation/providers/call_provider.dart';
import 'package:buddy_talk/features/home/presentation/screens/home_screen.dart';
import 'package:buddy_talk/features/podcast/presentation/screens/podcast_screen.dart';
import 'package:buddy_talk/features/premium/presentation/screens/premium_screen.dart';
import 'package:buddy_talk/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const BuddyTalkApp());
}

class BuddyTalkApp extends StatelessWidget {
  const BuddyTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
      ],
      child: MaterialApp(
        title: 'Buddy Talk',
        theme: AppTheme.darkTeal(),
        home: const RootScaffold(),
      ),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [HomeScreen(), PodcastScreen(), ProfileScreen(), PremiumScreen()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddy Talk'),
        actions: [
          TextButton(
            onPressed: () => context.read<AuthProvider>().signInWithGoogle(),
            child: const Text('Google Sign-In'),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.groups_2), label: 'Rooms'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.workspace_premium), label: 'Premium'),
        ],
      ),
    );
  }
}
