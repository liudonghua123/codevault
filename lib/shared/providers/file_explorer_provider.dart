import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/file_explorer/data/file_repository.dart';
import '../../features/file_explorer/domain/file_node.dart';

final fileRepositoryProvider = Provider((ref) => FileRepository());

final currentDirectoryProvider = StateProvider<String?>((ref) => null);

final fileTreeProvider = StateNotifierProvider<FileTreeNotifier, AsyncValue<List<FileNode>>>((ref) {
  final repository = ref.watch(fileRepositoryProvider);
  return FileTreeNotifier(repository);
});

final selectedFileProvider = StateProvider<FileNode?>((ref) => null);

class FileTreeNotifier extends StateNotifier<AsyncValue<List<FileNode>>> {
  final FileRepository _repository;

  FileTreeNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> loadDirectory(String path) async {
    state = const AsyncValue.loading();
    try {
      final nodes = await _repository.loadDirectory(path);
      state = AsyncValue.data(nodes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleExpand(FileNode node) async {
    if (node.type == FileType.file) return;

    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final index = currentState.indexWhere((n) => n.path == node.path);
    if (index == -1) return;

    List<FileNode> updatedChildren;
    if (node.children.isEmpty) {
      updatedChildren = await _repository.loadDirectory(node.path);
    } else {
      updatedChildren = [];
    }

    final updatedNode = node.copyWith(
      isExpanded: !node.isExpanded,
      children: updatedChildren,
    );

    final updatedList = List<FileNode>.from(currentState);
    updatedList[index] = updatedNode;
    state = AsyncValue.data(updatedList);
  }

  void refresh() async {
    final currentState = state.valueOrNull;
    if (currentState != null && currentState.isNotEmpty) {
      final pathParts = currentState.first.path.split(RegExp(r'[/\\]'));
      if (pathParts.length > 1) {
        pathParts.removeLast();
        await loadDirectory(pathParts.join(Platform.pathSeparator));
      }
    }
  }
}