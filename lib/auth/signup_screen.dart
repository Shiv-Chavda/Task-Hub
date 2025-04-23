import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/app/theme.dart';
import 'package:task_tracker/auth/auth_service.dart';
import 'package:task_tracker/utils/validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
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
    _passwordConfirmController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final error = await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (error != null) {
          if (error == 'verification_needed') {
            _showVerificationDialog(_emailController.text.trim());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully. Please log in.'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  void _showVerificationDialog(String email) {
    final isDarkMode = AppTheme.isDarkMode(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.mark_email_read,
              color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
            ),
            const SizedBox(width: 10),
            const Text('Verify Your Email'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We\'ve sent a verification link to:',
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
              'Please check your inbox and click the verification link to activate your account before logging in.',
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
              'Resend Email',
              style: TextStyle(
                color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to login screen
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Icon(
                  Icons.person_add_outlined,
                  size: 64,
                  color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a new account to use Task Tracker',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? AppTheme.darkSubtleTextColor : AppTheme.subtleTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                          helperText: 'Must be at least 6 characters long',
                        ),
                        obscureText: true,
                        validator: Validators.validatePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordConfirmController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
                        child: _isLoading
                            ? LoadingAnimationWidget.threeArchedCircle(
                                color: Colors.white,
                                size: 24,
                              )
                            : const Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}