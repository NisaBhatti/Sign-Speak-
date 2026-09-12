import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  final HistoryService _historyService = HistoryService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await _historyService.loadHistory();
    setState(() {});
  }

  // Filtered history
  List<Map<String, dynamic>> get _filteredHistory {
    if (_searchQuery.isEmpty) return _historyService.history;
    return _historyService.history.where((item) {
      return item['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['action']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Format date
  String _formatDate(String isoDate) {
    try {
      final DateTime date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? "PM" : "AM"}';
      } else if (difference.inDays < 2) {
        return 'Yesterday, ${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? "PM" : "AM"}';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  // Get icon for action
  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'favourite':
        return Icons.favorite;
      case 'translation':
        return Icons.translate;
      case 'gallery':
        return Icons.photo_library;
      case 'camera':
        return Icons.camera_alt;
      case 'video':
        return Icons.video_library;
      case 'dictionary':
        return Icons.menu_book;
      case 'alphabet':
        return Icons.abc;
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.history;
    }
  }

  // Get color for action
  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'favourite':
        return Colors.red;
      case 'translation':
        return Colors.green;
      case 'gallery':
        return Colors.purple;
      case 'camera':
        return Colors.blue;
      case 'video':
        return Colors.orange;
      case 'dictionary':
        return lightBlue;
      case 'alphabet':
        return marineBlue;
      default:
        return marineBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ========== APP BAR ==========
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: marineBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: marineBlue, size: 22),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      ),
                    ),
                    Text(
                      'History & Practice',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Delete All Button
                    if (_historyService.history.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _showClearDialog,
                          icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),

              // ========== SEARCH BAR ==========
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search your history...',
                      prefixIcon: Icon(Icons.search, color: lightBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              // ========== HISTORY LIST ==========
              Expanded(
                child: _filteredHistory.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _filteredHistory.length,
                        itemBuilder: (context, index) {
                          final item = _filteredHistory[index];
                          return _buildHistoryCard(item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== EMPTY STATE ==========
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [marineBlue, lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: marineBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.history,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No History Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: marineBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your activities will appear here',
            style: TextStyle(
              fontSize: 14,
              color: marineBlue.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ========== HISTORY CARD ==========
  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final action = item['action'] ?? '';
    final actionColor = _getActionColor(action);
    final icon = _getActionIcon(action);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: actionColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: actionColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Title + Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? 'Activity',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: marineBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(item['timestamp'] ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete Button
          GestureDetector(
            onTap: () => _deleteItem(item['id']),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade400,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Delete single item
  Future<void> _deleteItem(String id) async {
    await _historyService.deleteHistory(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted from history'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Clear all dialog
  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Clear History',
            style: TextStyle(color: marineBlue, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to clear all history?',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                await _historyService.clearAllHistory();
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All history cleared'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}