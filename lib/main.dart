import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/auth_service.dart';

// Uncomment both of these after running `flutterfire configure`
// (see README Setup step 3) — removed for now since an unused import
// fails `flutter analyze` in CI:
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Uncomment after running `flutterfire configure`:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MondayApp());
}

class MondayApp extends StatelessWidget {
  const MondayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MONDAY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const _AuthGate(),
    );
  }
}

/// Routes to [HomeScreen] if signed in, [LoginScreen] otherwise, and
/// updates automatically as the Firebase Auth state changes.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
