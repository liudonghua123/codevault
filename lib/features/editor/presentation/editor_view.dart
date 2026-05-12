import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/highlight.dart' show highlight;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/language_map.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/editor_provider.dart';

class EditorView extends ConsumerStatefulWidget {
  final EditorTab tab;

  const EditorView({super.key, required this.tab});

  @override
  ConsumerState<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends ConsumerState<EditorView> {
  late CodeController _controller;
  late String _lastContent;

  @override
  void initState() {
    super.initState();
    _lastContent = widget.tab.content;
    _initController();
  }

  void _initController() {
    final language = LanguageMap.getLanguage(widget.tab.name) ?? 'plaintext';
    final languageDef = _getLanguageDefinition(language);

    _controller = CodeController(
      text: widget.tab.content,
      language: languageDef,
    );

    _controller.addListener(_onContentChanged);
  }

  dynamic _getLanguageDefinition(String language) {
    // Map our language names to highlight.js language names
    const Map<String, String> languageMap = {
      'dart': 'dart',
      'javascript': 'javascript',
      'typescript': 'typescript',
      'python': 'python',
      'html': 'xml',
      'css': 'css',
      'json': 'json',
      'yaml': 'yaml',
      'xml': 'xml',
      'markdown': 'markdown',
      'sql': 'sql',
      'bash': 'bash',
      'go': 'go',
      'rust': 'rust',
      'java': 'java',
      'kotlin': 'kotlin',
      'swift': 'swift',
      'c': 'c',
      'cpp': 'cpp',
      'csharp': 'cs',
      'ruby': 'ruby',
      'php': 'php',
    };

    // Special case for plaintext (no highlighting)
    if (language == 'plaintext') return null;

    final langName = languageMap[language] ?? language;
    try {
      return highlight.parse('', language: langName).language;
    } catch (_) {
      return null;
    }
  }

  void _onContentChanged() {
    final newContent = _controller.text;
    if (newContent != _lastContent) {
      _lastContent = newContent;
      ref.read(openTabsProvider.notifier).updateTabContent(widget.tab.path, newContent);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkEditorBg : AppColors.lightEditorBg,
      child: CodeTheme(
        data: CodeThemeData(styles: _getThemeData(context)),
        child: SingleChildScrollView(
          child: CodeField(
            controller: _controller,
            textStyle: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 14,
              height: 1.5,
            ),
            gutterStyle: GutterStyle(
              width: 50,
              margin: 4,
              textStyle: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, TextStyle> _getThemeData(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return {
        'root': const TextStyle(backgroundColor: Color(0xFF1E1E1E), color: Color(0xFFD4D4D4)),
        'keyword': const TextStyle(color: Color(0xFF569CD6)),
        'built_in': const TextStyle(color: Color(0xFF4EC9B0)),
        'type': const TextStyle(color: Color(0xFF4EC9B0)),
        'literal': const TextStyle(color: Color(0xFF569CD6)),
        'number': const TextStyle(color: Color(0xFFB5CEA8)),
        'string': const TextStyle(color: Color(0xFFCE9178)),
        'comment': const TextStyle(color: Color(0xFF6A9955)),
        'doctag': const TextStyle(color: Color(0xFF608B4E)),
        'meta': const TextStyle(color: Color(0xFF9B9B9B)),
        'function': const TextStyle(color: Color(0xFFDCDCAA)),
        'class': const TextStyle(color: Color(0xFF4EC9B0)),
        'title': const TextStyle(color: Color(0xFFDCDCAA)),
        'params': const TextStyle(color: Color(0xFF9CDCFE)),
        'variable': const TextStyle(color: Color(0xFF9CDCFE)),
      };
    } else {
      return {
        'root': const TextStyle(backgroundColor: Color(0xFFFFFFFF), color: Color(0xFF383A42)),
        'keyword': const TextStyle(color: Color(0xFFA626A4)),
        'built_in': const TextStyle(color: Color(0xFF0184BC)),
        'type': const TextStyle(color: Color(0xFFC18401)),
        'literal': const TextStyle(color: Color(0xFF0184BC)),
        'number': const TextStyle(color: Color(0xFF986801)),
        'string': const TextStyle(color: Color(0xFF50A14F)),
        'comment': const TextStyle(color: Color(0xFFA0A1A7)),
        'doctag': const TextStyle(color: Color(0xFFC18401)),
        'meta': const TextStyle(color: Color(0xFF383A42)),
        'function': const TextStyle(color: Color(0xFF4078F2)),
        'class': const TextStyle(color: Color(0xFFC18401)),
        'title': const TextStyle(color: Color(0xFF4078F2)),
        'params': const TextStyle(color: Color(0xFF383A42)),
        'variable': const TextStyle(color: Color(0xFF383A42)),
      };
    }
  }
}