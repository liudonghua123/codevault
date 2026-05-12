class LanguageMap {
  static const Map<String, String> defaultMap = {
    // Dart
    'dart': 'dart',
    // JavaScript/TypeScript
    'js': 'javascript',
    'jsx': 'javascript',
    'ts': 'typescript',
    'tsx': 'typescript',
    'mjs': 'javascript',
    'cjs': 'javascript',
    // Python
    'py': 'python',
    'pyw': 'python',
    'pyx': 'python',
    // Web
    'html': 'html',
    'htm': 'html',
    'css': 'css',
    'scss': 'scss',
    'sass': 'scss',
    'less': 'less',
    'vue': 'xml',
    'svelte': 'xml',
    // Mobile
    'swift': 'swift',
    'kt': 'kotlin',
    'kts': 'kotlin',
    'java': 'java',
    // Backend
    'go': 'go',
    'rs': 'rust',
    'rb': 'ruby',
    'php': 'php',
    'c': 'c',
    'cpp': 'cpp',
    'cc': 'cpp',
    'cxx': 'cpp',
    'h': 'c',
    'hpp': 'cpp',
    'cs': 'csharp',
    // Data/Config
    'json': 'json',
    'yaml': 'yaml',
    'yml': 'yaml',
    'xml': 'xml',
    'toml': 'toml',
    'ini': 'ini',
    'env': 'bash',
    // Shell
    'sh': 'bash',
    'bash': 'bash',
    'zsh': 'bash',
    'fish': 'bash',
    'ps1': 'powershell',
    'psm1': 'powershell',
    // Database
    'sql': 'sql',
    // Documents
    'md': 'markdown',
    'markdown': 'markdown',
    'txt': 'plaintext',
    // Other
    'lua': 'lua',
    'r': 'r',
    'pl': 'perl',
    'pm': 'perl',
    'scala': 'scala',
    'groovy': 'groovy',
    'cmake': 'cmake',
    'makefile': 'makefile',
    'dockerfile': 'dockerfile',
    'graphql': 'graphql',
    'gql': 'graphql',
  };

  static String? getLanguage(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    return defaultMap[ext];
  }
}