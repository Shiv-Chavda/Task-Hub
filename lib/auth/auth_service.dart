import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker/auth/login_screen.dart';
import 'package:task_tracker/dashboard/dashboard_screen.dart';

class AuthService extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  User? get currentUser => supabase.auth.currentUser;
  
  AuthService() {
    supabase.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
  
  Future<String?> signUp(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      
      if (response.user != null) {
        final confirmedAt = response.user!.emailConfirmedAt;
        if (confirmedAt == null || DateTime.parse(confirmedAt).isBefore(DateTime(2000))) {
          return 'verification_needed';
        }
      }
      
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }
  
  bool isEmailVerified() {
    final user = supabase.auth.currentUser;
    if (user == null) return false;
    
    final confirmedAt = user.emailConfirmedAt;
    if (confirmedAt == null) return false;
    
    try {
      return DateTime.parse(confirmedAt).isAfter(DateTime(2000));
    } catch (e) {
      return false;
    }
  }
  
  Future<String?> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (!isEmailVerified()) {
        return 'Please verify your email before logging in';
      }
      
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }
  
  Future<String?> resendVerificationEmail(String email) async {
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }
  
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
  
  Widget authStateChange() {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session != null) {
            return const DashboardScreen();
          }
        }
        return const LoginScreen();
      },
    );
  }
}