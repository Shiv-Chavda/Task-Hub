import 'package:flutter/material.dart';
import 'package:task_tracker/app/theme.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, themeMode, _) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            themeMode == ThemeMode.system
                ? Icons.brightness_auto
                : themeMode == ThemeMode.light
                    ? Icons.brightness_high
                    : Icons.brightness_3,
            color: AppTheme.isDarkMode(context) 
                ? AppTheme.darkTextColor 
                : Colors.white,
          ),
          tooltip: 'Change theme',
          onSelected: (selectedThemeMode) {
            AppTheme.setThemeMode(selectedThemeMode);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: ThemeMode.light,
              child: _ThemeModeItem(
                icon: Icons.brightness_high,
                text: 'Light Mode',
              ),
            ),
            const PopupMenuItem(
              value: ThemeMode.dark,
              child: _ThemeModeItem(
                icon: Icons.brightness_3,
                text: 'Dark Mode',
              ),
            ),
            const PopupMenuItem(
              value: ThemeMode.system,
              child: _ThemeModeItem(
                icon: Icons.brightness_auto,
                text: 'System Default',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeModeItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ThemeModeItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}