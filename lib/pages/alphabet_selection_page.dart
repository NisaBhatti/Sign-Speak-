import 'package:flutter/material.dart';
import 'alphabet_detection_page.dart';

class AlphabetSelectionPage extends StatefulWidget {
  const AlphabetSelectionPage({Key? key}) : super(key: key);

  @override
  State<AlphabetSelectionPage> createState() => _AlphabetSelectionPageState();
}

class _AlphabetSelectionPageState extends State<AlphabetSelectionPage> {
  // ✅ Urdu alphabetical order
  final List<Map<String, String>> _alphabets = [
    {'name': 'alif',      'display': 'Alif',      'arabic': 'ا'},
    {'name': 'bay',       'display': 'Bay',       'arabic': 'ب'},
    {'name': 'pay',       'display': 'Pay',       'arabic': 'پ'},
    {'name': 'tay',       'display': 'Tay',       'arabic': 'ت'},
    {'name': 'tey',       'display': 'Tey',       'arabic': 'ٹ'},
    {'name': 'thay',      'display': 'Thay',      'arabic': 'ث'},
    {'name': 'jeem',      'display': 'Jeem',      'arabic': 'ج'},
    {'name': 'chay',      'display': 'Chay',      'arabic': 'چ'},
    {'name': 'khay',      'display': 'Khay',      'arabic': 'خ'},
    {'name': 'dal',       'display': 'Dal',       'arabic': 'د'},
    {'name': 'daal',      'display': 'Daal',      'arabic': 'ڈ'},
    {'name': 'zal',       'display': 'Zal',       'arabic': 'ذ'},
    {'name': 'ray',       'display': 'Ray',       'arabic': 'ر'},
    {'name': 'rray',      'display': 'Rray',      'arabic': 'ڑ'},
    {'name': 'zay',       'display': 'Zay',       'arabic': 'ز'},
    {'name': 'seen',      'display': 'Seen',      'arabic': 'س'},
    {'name': 'sheen',     'display': 'Sheen',     'arabic': 'ش'},
    {'name': 'suaad',     'display': 'Suaad',     'arabic': 'ص'},
    {'name': 'zvad',      'display': 'Zvad',      'arabic': 'ض'},
    {'name': 'toayn',     'display': 'Toayn',     'arabic': 'ط'},
    {'name': 'zoyn',      'display': 'Zoyn',      'arabic': 'ظ'},
    {'name': 'ain',       'display': 'Ain',       'arabic': 'ع'},
    {'name': 'ghain',     'display': 'Ghain',     'arabic': 'غ'},
    {'name': 'fe',        'display': 'Fe',        'arabic': 'ف'},
    {'name': 'quaaf',     'display': 'Quaaf',     'arabic': 'ق'},
    {'name': 'kaf',       'display': 'Kaf',       'arabic': 'ك'},
    {'name': 'gaf',       'display': 'Gaf',       'arabic': 'گ'},
    {'name': 'lam',       'display': 'Lam',       'arabic': 'ل'},
    {'name': 'mim',       'display': 'Mim',       'arabic': 'م'},
    {'name': 'noon',      'display': 'Noon',      'arabic': 'ن'},
    {'name': 'vao',       'display': 'Vao',       'arabic': 'و'},
    {'name': 'hamza',     'display': 'Hamza',     'arabic': 'ء'},
    {'name': 'choti_ye',  'display': 'Choti Ye',  'arabic': 'ی'},
    {'name': 'bari_ye',   'display': 'Bari Ye',   'arabic': 'ے'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Select Alphabet'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueAccent.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  '${_alphabets.length} alphabets available',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _alphabets.length,
              itemBuilder: (context, index) =>
                  _buildAlphabetCard(context, _alphabets[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlphabetCard(
      BuildContext context, Map<String, String> alphabet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlphabetDetectionPage(
              alphabet: alphabet['name']!,
              displayName: alphabet['display']!,
              arabic: alphabet['arabic']!,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              alphabet['arabic']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                alphabet['display']!,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}