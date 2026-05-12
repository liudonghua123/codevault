import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/file_node.dart';
import 'file_node_tile.dart';

class FileTreeWidget extends ConsumerWidget {
  final List<FileNode> nodes;

  const FileTreeWidget({super.key, required this.nodes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF252526)
          : const Color(0xFFF3F3F3),
      child: ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          return FileNodeTile(node: nodes[index]);
        },
      ),
    );
  }
}