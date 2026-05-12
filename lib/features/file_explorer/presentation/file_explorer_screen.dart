import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/file_explorer_provider.dart';
import 'file_tree_widget.dart';

class FileExplorerScreen extends ConsumerWidget {
  const FileExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDir = ref.watch(currentDirectoryProvider);
    final fileTree = ref.watch(fileTreeProvider);

    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(context, ref, currentDir),
          const Divider(height: 1),
          Expanded(
            child: currentDir == null
                ? _buildWelcomeView(context, ref)
                : _buildFileTree(context, ref, fileTree),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref, String? currentDir) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 48,
      color: isDark ? AppColors.darkSidebarBg : AppColors.lightSidebarBg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open Folder',
            onPressed: () => _openFolder(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: currentDir != null
                ? () => ref.read(fileTreeProvider.notifier).refresh()
                : null,
          ),
          const Spacer(),
          if (currentDir != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                currentDir,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
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

  Widget _buildWelcomeView(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Open a folder to get started',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _openFolder(context, ref),
            icon: const Icon(Icons.folder_open),
            label: const Text('Open Folder'),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTree(BuildContext context, WidgetRef ref, AsyncValue fileTree) {
    return fileTree.when(
      data: (nodes) => FileTreeWidget(nodes: nodes),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Future<void> _openFolder(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      ref.read(currentDirectoryProvider.notifier).state = result;
      ref.read(fileTreeProvider.notifier).loadDirectory(result);
    }
  }
}