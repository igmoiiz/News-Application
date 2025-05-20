import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationServices {
  //  Instance for Supabase Client
  final SupabaseClient _supabase = Supabase.instance.client;

  //  Method to Sign Up the User
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    final snackBar = ScaffoldMessenger.of(context);
    try {
      await _supabase.auth
          .signUp(email: email, password: password)
          .then((value) {
            snackBar.showSnackBar(
              SnackBar(
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                content: Text("Signed Up Successfully!"),
              ),
            );
          })
          .onError((error, stackTrace) {
            snackBar.showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                content: Text("Error Signing Up: $error"),
              ),
            );
          });
    } catch (error) {
      log(error.toString());
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
      await _supabase.auth
          .signInWithPassword(email: email, password: password)
          .then((value) {
            snackBar.showSnackBar(
              SnackBar(
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                content: Text("Signed In Successfully!"),
              ),
            );
          })
          .onError((error, stackTrace) {
            snackBar.showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                content: Text("Error Signing In: $error"),
              ),
            );
          });
    } catch (error) {
      log(error.toString());
    }
  }

  //  Method to Sign Out the User
  void signOut(BuildContext context) async {
    final snackBar = ScaffoldMessenger.of(context);
    try {
      await _supabase.auth
          .signOut()
          .then((value) {
            snackBar.showSnackBar(
              SnackBar(
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                content: Text("Signed Out Successfully!"),
              ),
            );
          })
          .onError((error, stackTrace) {
            snackBar.showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                content: Text("Error Signing Out: $error"),
              ),
            );
          });
    } catch (error) {
      log(error.toString());
    }
  }
}
