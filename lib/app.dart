import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/theme_provider.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/editor/presentation/editor_screen.dart';

class CodeVaultApp extends ConsumerWidget {
  const CodeVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'CodeVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const EditorScreen(),
      routes: {
        '/editor': (context) => const EditorScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}