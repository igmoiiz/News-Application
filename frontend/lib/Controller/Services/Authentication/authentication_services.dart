import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationServices {
  //  Instance for Supabase Client
  final SupabaseClient _supabase = Supabase.instance.client;

  //  Get current user
  User? get currentUser => _supabase.auth.currentUser;

  //  Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  //  Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  //  Method to Sign Up the User
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    final snackBar = ScaffoldMessenger.of(context);
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        snackBar.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Signed Up Successfully! Please check your email for verification.",
            ),
          ),
        );
        // Navigate to login page after successful signup
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (error) {
      log(error.toString());
      snackBar.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          content: Text("Error Signing Up: $error"),
        ),
      );
    }
  }

  //  Method to Sign In the User
  Future<void> signInUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    final snackBar = ScaffoldMessenger.of(context);
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        snackBar.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            content: Text("Signed In Successfully!"),
          ),
        );
        // Navigate to news feed after successful login
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/news');
        }
      }
    } catch (error) {
      log(error.toString());
      snackBar.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          content: Text("Error Signing In: $error"),
        ),
      );
    }
  }

  //  Method to Sign Out the User
  Future<void> signOut(BuildContext context) async {
    final snackBar = ScaffoldMessenger.of(context);
    try {
      await _supabase.auth.signOut();
      snackBar.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text("Signed Out Successfully!"),
        ),
      );
      // Navigate to login page after successful signout
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      log(error.toString());
      snackBar.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          content: Text("Error Signing Out: $error"),
        ),
      );
    }
  }

  //  Method to check if user is authenticated
  bool isAuthenticated() {
    return currentUser != null;
  }

  //  Method to get user email
  String? getUserEmail() {
    return currentUser?.email;
  }
}
