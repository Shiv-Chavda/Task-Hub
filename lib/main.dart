import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:task_tracker/app/theme.dart';
import 'package:task_tracker/auth/auth_service.dart';
import 'package:task_tracker/dashboard/task_model.dart';
import 'package:task_tracker/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await supabase.Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, TaskProvider>(
          create: (_) => TaskProvider(supabaseService: SupabaseService()),
          update: (_, authService, previousTaskProvider) => 
            TaskProvider(
              supabaseService: SupabaseService(),
              userId: authService.currentUser?.id,
            ),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.themeMode,
            builder: (context, themeMode, _) {
              return MaterialApp(
                title: 'Task Tracker',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                home: AuthWrapper(),
              );
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return authService.authStateChange();
  }
}