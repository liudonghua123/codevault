import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/file_explorer_provider.dart';
import '../domain/file_node.dart';

class FileNodeTile extends ConsumerWidget {
  final FileNode node;

  const FileNodeTile({super.key, required this.node});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedFile = ref.watch(selectedFileProvider);

    return InkWell(
      onTap: () => _onTap(ref),
      child: Container(
        height: 24,
        padding: EdgeInsets.only(left: 8.0 + node.depth * 16.0),
        color: selectedFile?.path == node.path
            ? (isDark ? AppColors.darkSelection : AppColors.lightSelection)
            : null,
        child: Row(
          children: [
            if (node.type == FileType.directory)
              Icon(
                node.isExpanded ? Icons.expand_more : Icons.chevron_right,
                size: 16,
              )
            else
              const SizedBox(width: 16),
            const SizedBox(width: 4),
            Icon(
              _getIcon(),
              size: 16,
              color: _getIconColor(),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                node.name,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkForeground : AppColors.lightForeground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    if (node.type == FileType.directory) {
      return node.isExpanded ? Icons.folder_open : Icons.folder;
    }
    final ext = node.name.split('.').last.toLowerCase();
    switch (ext) {
      case 'dart':
        return Icons.flutter_dash;
      case 'js':
      case 'jsx':
        return Icons.javascript;
      case 'ts':
      case 'tsx':
        return Icons.code;
      case 'py':
        return Icons.code;
      case 'html':
      case 'htm':
        return Icons.html;
      case 'css':
      case 'scss':
      case 'sass':
        return Icons.css;
      case 'json':
      case 'yaml':
      case 'yml':
        return Icons.data_object;
      case 'md':
        return Icons.article;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getIconColor() {
    if (node.type == FileType.directory) {
      return AppColors.folderColor;
    }
    final ext = node.name.split('.').last.toLowerCase();
    switch (ext) {
      case 'dart':
        return AppColors.dartFileColor;
      case 'js':
      case 'jsx':
        return AppColors.jsFileColor;
      case 'ts':
      case 'tsx':
        return AppColors.tsFileColor;
      case 'py':
        return AppColors.pyFileColor;
      case 'html':
      case 'htm':
        return AppColors.htmlFileColor;
      case 'css':
      case 'scss':
      case 'sass':
        return AppColors.cssFileColor;
      case 'json':
      case 'yaml':
      case 'yml':
        return AppColors.jsonFileColor;
      case 'md':
        return AppColors.mdFileColor;
      default:
        return Colors.grey;
    }
  }

  void _onTap(WidgetRef ref) {
    if (node.type == FileType.directory) {
      ref.read(fileTreeProvider.notifier).toggleExpand(node);
    } else {
      ref.read(selectedFileProvider.notifier).state = node;
    }
  }
}