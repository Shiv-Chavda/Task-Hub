import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/app/theme.dart';
import 'package:task_tracker/auth/auth_service.dart';
import 'package:task_tracker/auth/signup_screen.dart';
import 'package:task_tracker/utils/validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final error = await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (error != null) {
          if (error.contains('verify your email')) {
            _showVerificationReminderDialog(_emailController.text.trim());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        }
      }
    }
  }

  void _showVerificationReminderDialog(String email) {
    final isDarkMode = AppTheme.isDarkMode(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.mark_email_unread_outlined,
              color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
            ),
            const SizedBox(width: 10),
            const Text('Email Not Verified'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The account with email:',
              style: TextStyle(
                color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'requires email verification. Please check your inbox for the verification link we sent when you signed up.',
              style: TextStyle(
                color: isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final authService = Provider.of<AuthService>(context, listen: false);
              authService.resendVerificationEmail(email);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Verification email resent'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: Text(
              'Resend Verification Email',
              style: TextStyle(
                color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode(context);
    
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to continue using Task Tracker',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: Colors.white,
                                size: 24,
                              )
                            : const Text('Log In'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const SignupScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}