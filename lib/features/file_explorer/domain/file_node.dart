import 'dart:io';

enum FileType { file, directory }

class FileNode {
  final String name;
  final String path;
  final FileType type;
  final List<FileNode> children;
  final bool isExpanded;
  final int depth;

  const FileNode({
    required this.name,
    required this.path,
    required this.type,
    this.children = const [],
    this.isExpanded = false,
    this.depth = 0,
  });

  factory FileNode.fromFileSystemEntity(FileSystemEntity entity, {int depth = 0}) {
    final type = entity is Directory ? FileType.directory : FileType.file;
    return FileNode(
      name: entity.path.split(Platform.pathSeparator).last,
      path: entity.path,
      type: type,
      depth: depth,
    );
  }

  FileNode copyWith({
    String? name,
    String? path,
    FileType? type,
    List<FileNode>? children,
    bool? isExpanded,
    int? depth,
  }) {
    return FileNode(
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
      depth: depth ?? this.depth,
    );
  }
}