import 'dart:io';
import '../domain/file_node.dart';

class FileRepository {
  Future<List<FileNode>> loadDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      throw Exception('Directory does not exist: $path');
    }

    final entities = await dir.list().toList();
    entities.sort((a, b) {
      final aIsDir = a is Directory;
      final bIsDir = b is Directory;
      if (aIsDir && !bIsDir) return -1;
      if (!aIsDir && bIsDir) return 1;
      return a.path.compareTo(b.path);
    });

    return entities.map((e) => FileNode.fromFileSystemEntity(e)).toList();
  }

  Future<String> readFile(String path) async {
    final file = File(path);
    return await file.readAsString();
  }

  Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
  }

  Future<void> createFile(String path) async {
    final file = File(path);
    await file.create(recursive: true);
  }

  Future<void> createDirectory(String path) async {
    final dir = Directory(path);
    await dir.create(recursive: true);
  }

  Future<void> delete(String path) async {
    final type = await FileSystemEntity.type(path);
    if (type == FileSystemEntityType.directory) {
      await Directory(path).delete(recursive: true);
    } else {
      await File(path).delete();
    }
  }

  Future<void> rename(String oldPath, String newPath) async {
    final type = await FileSystemEntity.type(oldPath);
    if (type == FileSystemEntityType.directory) {
      await Directory(oldPath).rename(newPath);
    } else {
      await File(oldPath).rename(newPath);
    }
  }

  Future<bool> exists(String path) async {
    return await FileSystemEntity.type(path) != FileSystemEntityType.notFound;
  }

  Future<List<String>> getRecentDirectories() async {
    // Placeholder - will integrate with SharedPreferences
    return [];
  }
}