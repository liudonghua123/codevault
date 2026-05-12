import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/language_map.dart';

class SettingsRepository {
  static const _languageMapKey = 'language_map';
  static const _fontSizeKey = 'font_size';
  static const _tabSizeKey = 'tab_size';
  static const _showLineNumbersKey = 'show_line_numbers';
  static const _autoSaveKey = 'auto_save';
  static const _autoSaveIntervalKey = 'auto_save_interval';
  static const _sidebarWidthKey = 'sidebar_width';

  Future<Map<String, String>> getLanguageMap() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_languageMapKey);
    if (json != null) {
      return Map<String, String>.from(jsonDecode(json));
    }
    return Map<String, String>.from(LanguageMap.defaultMap);
  }

  Future<void> saveLanguageMap(Map<String, String> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageMapKey, jsonEncode(map));
  }

  Future<void> addLanguageMapping(String extension, String language) async {
    final map = await getLanguageMap();
    map[extension.toLowerCase()] = language;
    await saveLanguageMap(map);
  }

  Future<void> removeLanguageMapping(String extension) async {
    final map = await getLanguageMap();
    map.remove(extension.toLowerCase());
    await saveLanguageMap(map);
  }

  Future<int> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fontSizeKey) ?? 14;
  }

  Future<void> setFontSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontSizeKey, size);
  }

  Future<int> getTabSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tabSizeKey) ?? 4;
  }

  Future<void> setTabSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tabSizeKey, size);
  }

  Future<bool> getShowLineNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showLineNumbersKey) ?? true;
  }

  Future<void> setShowLineNumbers(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showLineNumbersKey, show);
  }

  Future<bool> getAutoSave() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoSaveKey) ?? true;
  }

  Future<void> setAutoSave(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSaveKey, enabled);
  }

  Future<int> getAutoSaveInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_autoSaveIntervalKey) ?? 30;
  }

  Future<void> setAutoSaveInterval(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_autoSaveIntervalKey, seconds);
  }

  Future<double> getSidebarWidth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_sidebarWidthKey) ?? 250;
  }

  Future<void> setSidebarWidth(double width) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sidebarWidthKey, width);
  }
}