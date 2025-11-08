// lib/services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<SharedPreferences> _prefs() async => await SharedPreferences.getInstance();

  // Daily goals helpers (keeps legacy keys)
  static Future<Map<String, dynamic>> loadDailyGoals() async {
    final p = await _prefs();
    final int hedefSize = p.getInt('hedefSize') ?? 0;
    final List<String> metins = [];
    final List<int> hedefs = [];
    final List<int> sayacs = [];
    for (int i = 0; i < hedefSize; i++) {
      metins.add(p.getString('metin$i') ?? '');
      hedefs.add(p.getInt('hedef$i') ?? 0);
      sayacs.add(p.getInt('sayac$i') ?? 0);
    }
    return {
      'metins': metins,
      'hedefs': hedefs,
      'sayacs': sayacs,
      'yuzde': p.getInt('yuzde') ?? 0,
      'ses': p.getBool('ses') ?? false,
      'titresim': p.getBool('titresim') ?? true,
      'geceModu': p.getBool('geceModu') ?? false,
      'bildirimSaati': p.getString('bildirimSaati') ?? '20:30',
      'bildirimIptal': p.getBool('bildirimIptal') ?? false,
    };
  }

  static Future<void> saveDailyGoals({
    required List<String> metins,
    required List<int> hedefs,
    required List<int> sayacs,
    required int yuzde,
  }) async {
    final p = await _prefs();
    await p.setInt('hedefSize', hedefs.length);
    await p.setInt('yuzde', yuzde);
    for (int i = 0; i < hedefs.length; i++) {
      await p.setString('metin$i', metins[i]);
      await p.setInt('hedef$i', hedefs[i]);
      await p.setInt('sayac$i', sayacs[i]);
    }
  }

  // Generic zikir storage using stringList keys (keeps existing pattern if used)
  static Future<List<String>> loadZikirByKey(String key) async {
    final p = await _prefs();
    return p.getStringList(key) ?? [];
  }

  static Future<void> saveZikirByKey(String key, List<String> data) async {
    final p = await _prefs();
    await p.setStringList(key, data);
  }

  static Future<void> setBool(String key, bool value) async {
    final p = await _prefs();
    await p.setBool(key, value);
  }

  static Future<bool> getBool(String key, {required bool or}) async {
    final p = await _prefs();
    return p.getBool(key) ?? or;
  }
}
