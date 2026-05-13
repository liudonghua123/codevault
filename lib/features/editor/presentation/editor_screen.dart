import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/editor_provider.dart';
import '../../../shared/providers/file_explorer_provider.dart';
import 'tab_bar_widget.dart';
import 'editor_view.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  void initState() {
    super.initState();
    // Open file when screen is opened with a selected file
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openSelectedFile();
    });
  }

  void _openSelectedFile() {
    final selectedFile = ref.read(selectedFileProvider);
    final tabs = ref.read(openTabsProvider);

    if (selectedFile != null) {
      final existingTab = tabs.where((t) => t.path == selectedFile.path).firstOrNull;
      if (existingTab == null) {
        _loadAndOpenFile(selectedFile.path, selectedFile.name);
      }
    }
  }

  Future<void> _loadAndOpenFile(String path, String name) async {
    final repository = ref.read(fileRepositoryProvider);
    try {
      final content = await repository.readFile(path);
      ref.read(openTabsProvider.notifier).openTab(EditorTab(
        path: path,
        name: name,
        content: content,
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(openTabsProvider);
    final activeIndex = ref.watch(activeTabIndexProvider);

    // Ensure there's always content to show
    final hasTabs = tabs.isNotEmpty;
    final activeTab = hasTabs && activeIndex < tabs.length ? tabs[activeIndex] : null;

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, ref, hasTabs),
          const Divider(height: 1),
          if (hasTabs) ...[
            TabBarWidget(
              tabs: tabs,
              activeIndex: activeIndex,
              onTabSelected: (index) {
                ref.read(activeTabIndexProvider.notifier).state = index;
              },
              onTabClosed: (index) {
                final tab = tabs[index];
                ref.read(openTabsProvider.notifier).closeTab(tab.path);
                // Adjust active index if needed
                final newTabs = ref.read(openTabsProvider);
                if (newTabs.isEmpty) {
                  ref.read(activeTabIndexProvider.notifier).state = 0;
                } else if (activeIndex >= newTabs.length) {
                  ref.read(activeTabIndexProvider.notifier).state = newTabs.length - 1;
                }
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: activeTab != null
                  ? EditorView(tab: activeTab)
                  : _buildEmptyState(),
            ),
            _buildStatusBar(activeTab),
          ] else
            Expanded(child: _buildEmptyState()),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref, bool hasTabs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 48,
      color: isDark ? AppColors.darkSidebarBg : AppColors.lightSidebarBg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              // Clear selection and go back
              ref.read(selectedFileProvider.notifier).state = null;
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          if (hasTabs)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () => _saveCurrentFile(ref),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: hasTabs ? () {} : null,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }

  void _saveCurrentFile(WidgetRef ref) async {
    final tabs = ref.read(openTabsProvider);
    final activeIndex = ref.read(activeTabIndexProvider);

    if (tabs.isEmpty || activeIndex >= tabs.length) return;

    final tab = tabs[activeIndex];
    final repository = ref.read(fileRepositoryProvider);

    try {
      await repository.writeFile(tab.path, tab.content);
      ref.read(openTabsProvider.notifier).markTabSaved(tab.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File saved'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No file selected'),
        ],
      ),
    );
  }

  Widget _buildStatusBar(EditorTab? tab) {
    if (tab == null) return const SizedBox(height: 24);
    return Container(
      height: 24,
      color: AppColors.darkPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Text(
            'Ln 1, Col 1',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const Spacer(),
          const Text(
            'UTF-8',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(width: 16),
          Text(
            tab.name.split('.').last.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}