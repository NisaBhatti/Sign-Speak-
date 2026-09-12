import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  List<Map<String, dynamic>> _history = [];

  // Load history from SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('history');
    if (historyJson != null) {
      final List<dynamic> decoded = json.decode(historyJson);
      _history = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  // Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_history);
    await prefs.setString('history', encoded);
  }

  // ✅ Add new history entry
  Future<void> addHistory({
    required String title,
    required String action,
    String? details,
    String? imagePath,
  }) async {
    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'action': action,
      'details': details ?? '',
      'imagePath': imagePath ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    };

    _history.insert(0, entry); // Latest pehle
    await _saveHistory();
  }

  // Delete single history entry
  Future<void> deleteHistory(String id) async {
    _history.removeWhere((item) => item['id'] == id);
    await _saveHistory();
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    _history.clear();
    await _saveHistory();
  }

  // Get all history
  List<Map<String, dynamic>> get history => _history;

  // Get history count
  int get historyCount => _history.length;
}