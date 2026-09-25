import 'package:flutter/material.dart';
import 'alphabet_detection_page.dart';

class AlphabetSelectionPage extends StatefulWidget {
  const AlphabetSelectionPage({Key? key}) : super(key: key);

  @override
  State<AlphabetSelectionPage> createState() => _AlphabetSelectionPageState();
}

class _AlphabetSelectionPageState extends State<AlphabetSelectionPage> {
  // ✅ Theme colors (same as HomeScreen)
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

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
      // ✅ Same gradient background as HomeScreen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color1, color2],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ============================
              // TOP BAR (matches HomeScreen style)
              // ============================
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: marineBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: marineBlue, size: 22),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(
                            minWidth: 40, minHeight: 40),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Select Alphabet',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ============================
              // INFO BANNER
              // ============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: lightBlue.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: lightBlue, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${_alphabets.length} alphabets available',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: marineBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ============================
              // ALPHABET GRID
              // ============================
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
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
        ),
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
          // ✅ Blue theme matching HomeScreen cards
          gradient: LinearGradient(
            colors: [
              marineBlue.withValues(alpha: 0.9),
              lightBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: marineBlue.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
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