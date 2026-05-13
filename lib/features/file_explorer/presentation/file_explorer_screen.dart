import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/file_explorer_provider.dart';
import '../../../shared/providers/editor_provider.dart';
import '../../editor/presentation/editor_screen.dart';
import 'file_tree_widget.dart';

class FileExplorerScreen extends ConsumerStatefulWidget {
  const FileExplorerScreen({super.key});

  @override
  ConsumerState<FileExplorerScreen> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends ConsumerState<FileExplorerScreen> {
  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.file_open),
            tooltip: 'Open File',
            onPressed: () => _openFile(context, ref),
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
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _openFile(context, ref),
            icon: const Icon(Icons.file_open),
            label: const Text('Open File'),
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

  Future<void> _openFile(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        final fileName = file.name;
        final repository = ref.read(fileRepositoryProvider);
        try {
          final content = await repository.readFile(file.path!);
          ref.read(openTabsProvider.notifier).openTab(EditorTab(
            path: file.path!,
            name: fileName,
            content: content,
          ));

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditorScreen()),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to open file: $e')),
            );
          }
        }
      }
    }
  }
}