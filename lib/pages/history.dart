import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color color4 = Color(0xFF6CC2C0);   // Teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation History',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: marineBlue,                // Dark blue
          primaryContainer: lightBlue,        // Light blue
          secondary: color4,                  // Teal
          secondaryContainer: color2,          // Light teal
          tertiary: color1,                    // Light blue-green as background
          surface: color1,                      // Light blue-green
          onSurface: marineBlue,                // Dark blue for text
        ),
        fontFamily: 'Epilogue',
        appBarTheme: AppBarTheme(
          backgroundColor: color1,              // Light blue-green
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
            color: lightBlue,                    // Light blue
          ),
          iconTheme: IconThemeData(
            color: marineBlue,                    // Dark blue
          ),
        ),
      ),
      home: const TranslationHistoryScreen(),
    );
  }
}

class TranslationHistoryScreen extends StatefulWidget {
  const TranslationHistoryScreen({super.key});

  @override
  State<TranslationHistoryScreen> createState() => _TranslationHistoryScreenState();
}

class _TranslationHistoryScreenState extends State<TranslationHistoryScreen> {
  // Color scheme matching your app's palette
  static const Color color1 = Color(0xFFCFE8EA);   // Light blue-green
  static const Color color2 = Color(0xFFACD9D9);   // Light teal
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84); // Dark blue
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176); // Light blue          // Cream for contrast

  final List<TranslationItem> _translationItems = [
    TranslationItem(
      text: 'Hello, how are you?',
      timestamp: 'Today, 10:45 AM',
      isStarred: false,
    ),
    TranslationItem(
      text: 'Thank you',
      timestamp: 'Yesterday, 3:20 PM',
      isStarred: true,
    ),
    TranslationItem(
      text: 'Good morning',
      timestamp: 'Dec 25, 2025, 9:00 AM',
      isStarred: false,
    ),
    TranslationItem(
      text: 'What\'s your name?',
      timestamp: 'Dec 28, 2025, 5:15 PM',
      isStarred: false,
    ),
  ];

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = _searchText.isEmpty
        ? _translationItems
        : _translationItems.where((item) =>
            item.text.toLowerCase().contains(_searchText.toLowerCase())).toList();

    final isEmpty = filteredItems.isEmpty;

    return Scaffold(
      backgroundColor: color1, // Light blue-green
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: color1.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Back button with gradient
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [lightBlue, marineBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: marineBlue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  // Title
                  Expanded(
                    child: Text(
                      'History & Practice',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                        color: marineBlue, // Dark blue
                      ),
                    ),
                  ),
                  // Empty space for alignment
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightBlue.withOpacity(0.3)), 
                  color: Colors.white.withOpacity(0.7),
                  boxShadow: [
                    BoxShadow(
                      color: marineBlue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Search icon
                    Container(
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Icon(
                        Icons.search,
                        size: 24,
                        color: marineBlue, // Dark blue
                      ),
                    ),
                    // Search field
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search your translations...',
                          hintStyle: TextStyle(
                            color: lightBlue.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        style: TextStyle(
                          color: marineBlue, // Dark blue
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 8),
                        ...filteredItems.map((item) => _buildTranslationCard(item)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationCard(TranslationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, color1.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: marineBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main text - Marine Blue
                Text(
                  item.text,
                  style: TextStyle(
                    color: marineBlue, // Dark blue
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Timestamp - Light Blue
                Text(
                  item.timestamp,
                  style: TextStyle(
                    color: lightBlue, // Light blue
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              // Replay button with gradient background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue.withOpacity(0.1), marineBlue.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    _replayTranslation(item);
                  },
                  icon: const Icon(Icons.replay, size: 20),
                  color: marineBlue, // Dark blue
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 8),
              // Star button with gradient background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightBlue.withOpacity(0.1), marineBlue.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      item.isStarred = !item.isStarred;
                    });
                  },
                  icon: Icon(
                    item.isStarred ? Icons.star : Icons.star_border,
                    size: 20,
                    color: item.isStarred 
                        ? lightBlue // Light blue for starred
                        : marineBlue, // Dark blue for unstarred
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Waving hand icon with gradient
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightBlue, marineBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: marineBlue.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.waving_hand,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          // Title - Marine Blue
          Text(
            'No translations yet.',
            style: TextStyle(
              color: marineBlue, // Dark blue
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle - Light Blue
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Start a new conversation to see your history here!',
              style: TextStyle(
                color: lightBlue, // Light blue
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _replayTranslation(TranslationItem item) {
    // Implement replay functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Replaying: ${item.text}'),
        backgroundColor: lightBlue, // Light blue
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class TranslationItem {
  String text;
  String timestamp;
  bool isStarred;

  TranslationItem({
    required this.text,
    required this.timestamp,
    required this.isStarred,
  });
}