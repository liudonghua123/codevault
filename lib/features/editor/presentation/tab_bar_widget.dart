import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TabBarWidget extends StatelessWidget {
  final List tabs;
  final int activeIndex;
  final Function(int) onTabSelected;
  final Function(int) onTabClosed;

  const TabBarWidget({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onTabSelected,
    required this.onTabClosed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 36,
      color: isDark ? AppColors.darkSidebarBg : AppColors.lightSidebarBg,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isActive = index == activeIndex;
          return _buildTab(context, tab, isActive, index, isDark);
        },
      ),
    );
  }

  Widget _buildTab(BuildContext context, dynamic tab, bool isActive, int index, bool isDark) {
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? AppColors.darkBackground : AppColors.lightBackground)
              : null,
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.darkPrimary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.isModified)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkPrimary,
                ),
              ),
            Text(
              tab.name,
              style: TextStyle(
                fontSize: 13,
                color: isActive
                    ? (isDark ? AppColors.darkForeground : AppColors.lightForeground)
                    : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => onTabClosed(index),
              child: const Icon(Icons.close, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}