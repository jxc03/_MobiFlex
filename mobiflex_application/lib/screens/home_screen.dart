import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

/// The home screen for signed-in users.
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobiFlex'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
              } catch (_) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to log out. Please try again.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to MobiFlex!')),
    );
  }
}
