import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyPrefix =
      'meteoratlas_'; // Prefix pro klíče, abychom se vyhnuli kolizím

  // Metoda pro uložení hodnoty do lokálního úložiště
  static Future<void> saveValue(String key, dynamic value) async {
    final preferences = await SharedPreferences.getInstance();
    key = _getFullKey(key);
    if (value is int) {
      preferences.setInt(key, value);
    } else if (value is double) {
      preferences.setDouble(key, value);
    } else if (value is bool) {
      preferences.setBool(key, value);
    } else if (value is String) {
      preferences.setString(key, value);
    } else if (value is List<String>) {
      preferences.setStringList(key, value);
    } else {
      throw Exception('Unsupported value type');
    }
  }

  // Metoda pro získání hodnoty z lokálního úložiště
  static Future<dynamic> getValue(String key, {dynamic defaultValue}) async {
    final preferences = await SharedPreferences.getInstance();
    key = _getFullKey(key);
    if (preferences.containsKey(key)) {
      return preferences.get(key) ?? defaultValue;
    } else {
      return defaultValue;
    }
  }

  // Metoda pro smazání hodnoty z lokálního úložiště
  static Future<void> removeValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    key = _getFullKey(key);
    if (preferences.containsKey(key)) {
      preferences.remove(key);
    }
  }

  // Metoda pro kontrolu, zda hodnota existuje v lokálním úložišti
  static Future<bool> containsKey(String key) async {
    final preferences = await SharedPreferences.getInstance();
    key = _getFullKey(key);
    return preferences.containsKey(key);
  }

  // Pomocná metoda pro získání plného klíče s prefixem
  static String _getFullKey(String key) {
    return '$_keyPrefix$key';
  }
}
