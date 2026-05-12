import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../../shared/providers/settings_provider.dart';
import '../data/settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDarkMode = ref.watch(themeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final tabSize = ref.watch(tabSizeProvider);
    final showLineNumbers = ref.watch(showLineNumbersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDark ? AppColors.darkSidebarBg : AppColors.lightSidebarBg,
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark/light theme'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(themeProvider.notifier).setDarkMode(value);
            },
          ),
          // Font Size
          ListTile(
            title: const Text('Font Size'),
            subtitle: Text('$fontSize px'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: fontSize.toDouble(),
                min: 10,
                max: 24,
                divisions: 14,
                onChanged: (value) {
                  ref.read(fontSizeProvider.notifier).setSize(value.round());
                },
              ),
            ),
          ),
          // Tab Size
          ListTile(
            title: const Text('Tab Size'),
            subtitle: Text('$tabSize spaces'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: tabSize.toDouble(),
                min: 2,
                max: 8,
                divisions: 6,
                onChanged: (value) {
                  ref.read(tabSizeProvider.notifier).setSize(value.round());
                },
              ),
            ),
          ),
          // Show Line Numbers
          SwitchListTile(
            title: const Text('Show Line Numbers'),
            subtitle: const Text('Display line numbers in editor'),
            value: showLineNumbers,
            onChanged: (value) {
              ref.read(showLineNumbersProvider.notifier).toggle();
            },
          ),
          const Divider(),
          // Language Mappings
          ListTile(
            title: const Text('Language Mappings'),
            subtitle: const Text('Manage file extension to language mappings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageMappingsDialog(context, ref),
          ),
          const Divider(),
          // About Section
          _buildSectionHeader(context, 'About'),
          const ListTile(
            title: Text('CodeVault'),
            subtitle: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showLanguageMappingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => LanguageMappingsDialog(repository: ref.watch(settingsRepositoryProvider)),
    );
  }
}

class LanguageMappingsDialog extends StatefulWidget {
  final SettingsRepository repository;

  const LanguageMappingsDialog({super.key, required this.repository});

  @override
  State<LanguageMappingsDialog> createState() => _LanguageMappingsDialogState();
}

class _LanguageMappingsDialogState extends State<LanguageMappingsDialog> {
  late Future<Map<String, String>> _mappingsFuture;

  @override
  void initState() {
    super.initState();
    _mappingsFuture = widget.repository.getLanguageMap();
  }

  void _refresh() {
    setState(() {
      _mappingsFuture = widget.repository.getLanguageMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Language Mappings'),
      content: SizedBox(
        width: 400,
        height: 400,
        child: FutureBuilder<Map<String, String>>(
          future: _mappingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final mappings = snapshot.data ?? {};
            return Column(
              children: [
                // Add new mapping
                _buildAddMappingRow(),
                const Divider(),
                // Mappings list
                Expanded(
                  child: ListView.builder(
                    itemCount: mappings.length,
                    itemBuilder: (context, index) {
                      final entry = mappings.entries.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text('.${entry.key}'),
                        subtitle: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () async {
                            await widget.repository.removeLanguageMapping(entry.key);
                            _refresh();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildAddMappingRow() {
    final extensionController = TextEditingController();
    final languageController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: extensionController,
            decoration: const InputDecoration(
              labelText: 'Extension',
              hintText: 'e.g., mylang',
              isDense: true,
              prefixText: '.',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: languageController,
            decoration: const InputDecoration(
              labelText: 'Language',
              hintText: 'e.g., plaintext',
              isDense: true,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final ext = extensionController.text.trim();
            final lang = languageController.text.trim();
            if (ext.isNotEmpty && lang.isNotEmpty) {
              await widget.repository.addLanguageMapping(ext, lang);
              _refresh();
              extensionController.clear();
              languageController.clear();
            }
          },
        ),
      ],
    );
  }
}