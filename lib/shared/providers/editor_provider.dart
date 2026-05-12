import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorTab {
  final String path;
  final String name;
  final String content;
  final bool isModified;
  final int cursorPosition;

  const EditorTab({
    required this.path,
    required this.name,
    required this.content,
    this.isModified = false,
    this.cursorPosition = 0,
  });

  EditorTab copyWith({
    String? path,
    String? name,
    String? content,
    bool? isModified,
    int? cursorPosition,
  }) {
    return EditorTab(
      path: path ?? this.path,
      name: name ?? this.name,
      content: content ?? this.content,
      isModified: isModified ?? this.isModified,
      cursorPosition: cursorPosition ?? this.cursorPosition,
    );
  }
}

final openTabsProvider = StateNotifierProvider<OpenTabsNotifier, List<EditorTab>>((ref) {
  return OpenTabsNotifier();
});

final activeTabIndexProvider = StateProvider<int>((ref) => 0);

class OpenTabsNotifier extends StateNotifier<List<EditorTab>> {
  OpenTabsNotifier() : super([]);

  void openTab(EditorTab tab) {
    final existingIndex = state.indexWhere((t) => t.path == tab.path);
    if (existingIndex < 0) {
      state = [...state, tab];
    }
  }

  void closeTab(String path) {
    state = state.where((t) => t.path != path).toList();
  }

  void updateTabContent(String path, String content) {
    state = state.map((t) {
      if (t.path == path) {
        return t.copyWith(content: content, isModified: true);
      }
      return t;
    }).toList();
  }

  void markTabSaved(String path) {
    state = state.map((t) {
      if (t.path == path) {
        return t.copyWith(isModified: false);
      }
      return t;
    }).toList();
  }
}