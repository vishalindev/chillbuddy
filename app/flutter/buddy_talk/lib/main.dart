import 'package:buddy_talk/core/theme/app_theme.dart';
import 'package:buddy_talk/features/auth/presentation/providers/auth_provider.dart';
import 'package:buddy_talk/features/auth/presentation/screens/login_screen.dart';
import 'package:buddy_talk/features/call/presentation/providers/call_provider.dart';
import 'package:buddy_talk/features/home/presentation/screens/home_screen.dart';
import 'package:buddy_talk/features/podcast/presentation/screens/podcast_screen.dart';
import 'package:buddy_talk/features/profile/presentation/providers/profile_provider.dart';
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
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Buddy Talk',
        theme: AppTheme.darkTeal(),
        home: const AppEntry(),
      ),
    );
  }
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }
    return const RootScaffold();
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
    const pages = [HomeScreen(), PodcastScreen(), ProfileScreen()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddy Talk'),
        actions: [
          TextButton(
            onPressed: () => context.read<AuthProvider>().signOut(),
            child: const Text('Logout'),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.groups_2), label: 'Pods'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
