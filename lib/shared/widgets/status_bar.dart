import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusBar extends StatelessWidget {
  final String? fileName;
  final String language;
  final int line;
  final int column;

  const StatusBar({
    super.key,
    this.fileName,
    this.language = 'Plain Text',
    this.line = 1,
    this.column = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: AppColors.darkPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (fileName != null) ...[
            Text(
              fileName!,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 16),
          ],
          Text(
            'Ln $line, Col $column',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const Spacer(),
          const Text(
            'UTF-8',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(width: 16),
          Text(
            language,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}