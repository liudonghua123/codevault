import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/editor_provider.dart';
import '../../../shared/providers/file_explorer_provider.dart';
import 'tab_bar_widget.dart';
import 'editor_view.dart';

class EditorScreen extends ConsumerWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(openTabsProvider);
    final activeIndex = ref.watch(activeTabIndexProvider);
    final selectedFile = ref.watch(selectedFileProvider);

    // Open file when selected
    if (selectedFile != null) {
      final existingTab = tabs.where((t) => t.path == selectedFile.path).firstOrNull;
      if (existingTab == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final repository = ref.read(fileRepositoryProvider);
          try {
            final content = await repository.readFile(selectedFile.path);
            ref.read(openTabsProvider.notifier).openTab(EditorTab(
              path: selectedFile.path,
              name: selectedFile.name,
              content: content,
            ));
          } catch (e) {
            // Handle error silently
          }
        });
      }
    }

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, ref),
          const Divider(height: 1),
          if (tabs.isNotEmpty) ...[
            TabBarWidget(
              tabs: tabs,
              activeIndex: activeIndex,
              onTabSelected: (index) {
                ref.read(activeTabIndexProvider.notifier).state = index;
              },
              onTabClosed: (index) {
                final tab = tabs[index];
                ref.read(openTabsProvider.notifier).closeTab(tab.path);
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: tabs.isNotEmpty && activeIndex < tabs.length
                  ? EditorView(tab: tabs[activeIndex])
                  : _buildEmptyState(),
            ),
            _buildStatusBar(tabs.isNotEmpty && activeIndex < tabs.length ? tabs[activeIndex] : null),
          ] else
            Expanded(child: _buildEmptyState()),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref) {
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
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.code, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Select a file to edit'),
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