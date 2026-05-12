import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/settings_repository.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, int>((ref) {
  return FontSizeNotifier(ref.watch(settingsRepositoryProvider));
});

class FontSizeNotifier extends StateNotifier<int> {
  final SettingsRepository _repository;
  FontSizeNotifier(this._repository) : super(14) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getFontSize();
  }

  Future<void> setSize(int size) async {
    state = size;
    await _repository.setFontSize(size);
  }
}

final tabSizeProvider = StateNotifierProvider<TabSizeNotifier, int>((ref) {
  return TabSizeNotifier(ref.watch(settingsRepositoryProvider));
});

class TabSizeNotifier extends StateNotifier<int> {
  final SettingsRepository _repository;
  TabSizeNotifier(this._repository) : super(4) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getTabSize();
  }

  Future<void> setSize(int size) async {
    state = size;
    await _repository.setTabSize(size);
  }
}

final showLineNumbersProvider = StateNotifierProvider<ShowLineNumbersNotifier, bool>((ref) {
  return ShowLineNumbersNotifier(ref.watch(settingsRepositoryProvider));
});

class ShowLineNumbersNotifier extends StateNotifier<bool> {
  final SettingsRepository _repository;
  ShowLineNumbersNotifier(this._repository) : super(true) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getShowLineNumbers();
  }

  Future<void> toggle() async {
    state = !state;
    await _repository.setShowLineNumbers(state);
  }
}