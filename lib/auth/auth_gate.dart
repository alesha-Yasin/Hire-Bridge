import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/login_page.dart';
import 'package:hirebridge/Frontend/UserData/user_type_selection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return const UserTypeSelection();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

