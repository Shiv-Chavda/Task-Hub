import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Light Theme
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFFA5B4FC);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color textColor = Color(0xFF1F2937);
  static const Color subtleTextColor = Color(0xFF6B7280);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  
  // Colors - Dark Theme
  static const Color darkPrimaryColor = Color(0xFF818CF8);
  static const Color darkSecondaryColor = Color(0xFFA5B4FC);
  static const Color darkBackgroundColor = Color(0xFF111827);
  static const Color darkSurfaceColor = Color(0xFF1F2937);
  static const Color darkTextColor = Color(0xFFF9FAFB);
  static const Color darkSubtleTextColor = Color(0xFFD1D5DB);
  
  static final _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  
  static ValueNotifier<ThemeMode> get themeMode => _themeMode;
  static ThemeMode get currentThemeMode => _themeMode.value;
  static void setThemeMode(ThemeMode mode) => _themeMode.value = mode;
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE5E7EB),
      brightness: Brightness.light,
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: darkPrimaryColor,
      colorScheme: ColorScheme.dark(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        error: errorColor,
        background: darkBackgroundColor,
        surface: darkSurfaceColor,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        color: darkSurfaceColor,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextColor,
        ),
        iconTheme: const IconThemeData(color: darkTextColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: darkTextColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkSubtleTextColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkSubtleTextColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: darkSubtleTextColor),
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkSurfaceColor,
      dividerColor: darkSurfaceColor.withOpacity(0.4),
      brightness: Brightness.dark,
    );
  }
  
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}