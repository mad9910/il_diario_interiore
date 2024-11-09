import 'package:shared_preferences.dart';
import 'dart:convert';
import '../models/saved_item.dart';

class StorageService {
  static const String SAVED_ITEMS_KEY = 'saved_items';
  static const String LAST_MESSAGE_DATE_KEY = 'last_message_date';
  static const String LAST_STORY_DATE_KEY = 'last_story_date';
  
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Salva un nuovo elemento
  Future<bool> saveItem(SavedItem item) async {
    List<SavedItem> items = await getSavedItems();
    items.add(item);
    return await _prefs.setString(
      SAVED_ITEMS_KEY,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  // Recupera tutti gli elementi salvati
  Future<List<SavedItem>> getSavedItems() async {
    final String? itemsJson = _prefs.getString(SAVED_ITEMS_KEY);
    if (itemsJson == null) return [];
    
    List<dynamic> decoded = jsonDecode(itemsJson);
    return decoded.map((item) => SavedItem.fromJson(item)).toList();
  }

  // Salva la data dell'ultimo messaggio mostrato
  Future<bool> setLastMessageDate(DateTime date) async {
    return await _prefs.setString(LAST_MESSAGE_DATE_KEY, date.toIso8601String());
  }

  // Recupera la data dell'ultimo messaggio
  DateTime? getLastMessageDate() {
    final dateStr = _prefs.getString(LAST_MESSAGE_DATE_KEY);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // Simili funzioni per le storie
  Future<bool> setLastStoryDate(DateTime date) async {
    return await _prefs.setString(LAST_STORY_DATE_KEY, date.toIso8601String());
  }

  DateTime? getLastStoryDate() {
    final dateStr = _prefs.getString(LAST_STORY_DATE_KEY);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }
}
