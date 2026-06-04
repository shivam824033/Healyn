import 'package:flutter/material.dart';

/// Shown while [AuthStatus] is `unknown` (the token store is being read). The
/// router replaces it with /login or /home as soon as the status resolves.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
