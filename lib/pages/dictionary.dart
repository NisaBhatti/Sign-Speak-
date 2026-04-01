import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Dictionary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lexend',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 25, 19, 132), // darkBlue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const DictionaryPage(),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  // Updated color palette from live camera page
  static const Color color1 = Color(0xFFCFE8EA);   // #cfe8ea - Light blue-green
  static const Color darkBlue = Color.fromARGB(255, 25, 19, 132); // dark Blue
  
  final List<Map<String, String>> signCards = [
    {
      'title': 'Hello',
      'category': 'Greetings',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCO5_eGbY9Wm_GFh6GOtiEz0htudv4rgt2YKiST0W6O39nzM5Zaz1YXwGUL17i7oIPPGvJb0UGy1eEr4A2nMfoeJCysncA-hbxyncklERe7Q0U5vQSK_XWXeUfdDU8YLd6XUOKs-TO4mtGdLct0sRjRxskHu_InRj0sIQBrnU2PamJj94ZWlF3135kMSiE8wy7dlVbX7fC7kfL5quB4_ot8hL-CJXzO6THPpMqdxpe_MUyPXHGB4SHhFYfUPJ6bdcD7ZkyzIQktnhg'
    },
    {
      'title': 'Thank You',
      'category': 'Etiquette',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZyC1ygO5xJ0ii3u-fRKJvoT10W6oOV9AtmSdup6-__65iSrY7965K2DNoYAWMsKOhsxr65FlkGCg_uyMmo2Ny3l4BQMWbig6uCNM5U73S_GvezSMKRzdD31QHrqqDH8wjIh3mv7cEzBnIkSO69rR74hQ1-GR2c3M0Fdm-cckcVl5ZvItvzzYAr4WuZ238mV0udWl7lPFlg4XfP2-Jlsu2AWAOqMnEuYMK5Lum64UZYL2Fs-s-Ki6UbWlAw4d0OYB4UjQ5aiW6E-U'
    },
    {
      'title': 'Please',
      'category': 'Etiquette',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuADf_WwE7oRxAgraHS_mY4yuC0l9zWEa0qYjQVwiVT9vID9JYIkOL2AxfiyI3dX1-fxHJ0QdaDh6u152rBd0RTxfJ_oUgTtJbcsQe5r1myGaN_q2xK7t6L7P3VBybypJo0U4ilHUMwFoGp-6YKraF6y2o-MKsAC3iumGMK6hIDB12UZ13906tZbuBppl1vv6bJQQdmsbzwP5MIRgLcPzvJGHGoeK_sIEhigjRwthahNoLig0WVFGmaGSa5vdVNFqTClAk7rv99KJFo'
    },
    {
      'title': 'Help',
      'category': 'Essential',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD4GYZhpynq_74O9IlJsAMdEKH5XnJJMlOAr9v4Gt7mKTqMFSRWtm8-7jdP_-v1FA4GEq_cwKRCr0nhYNngaQoCIT1Ps0Pw-QHf8UeoXSVPhQehburG5xzVR5lIwJ1ht_4wz2QpYgZXEGS-Kl1xgo-_-ztNglPEcsoiB9m3iLckvQ-QfcjC8a73VJVY_gaOa8Jh5FR6tUr89jO3LWDAcCqpIvlzSR0RFMyGKJ3PfqkUVHVj2cam2pjNUGxkeNGzImBU95MwXy75b5Y'
    },
    {
      'title': 'Family',
      'category': 'People',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQ5BfG-UlptMVKSyr8iTKzpMNWtDiPRQTaVS4XdMFXUvoh-xg-W4aZhq7aX7BqOVCtTewgo8PA5dlE56hO1K8KqkC2aRHkxTkbzMBm03RcnLmErCLxD7hkMgG_gT1WAGQmYPnGTSzgYaWWOPyBeySDaCQZQ445AQqtwnoxgSKpk-IbDPJmsZycO8Wb_UOa9PjF7sCCTQkucp5wXrNZpQMVt5L1Nt36ASaDvKFN3whmFMGzyCtRIHyGui6l-YPsuDN6j1IxGxVnej0'
    },
    {
      'title': 'Learn',
      'category': 'Action',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCF1FfA7KbOw6J1JEDjTfoJPlwxhclKNoKLX8htgTsaLhZxiTvf400cmRWKfM7ZIMO98TvfBgNg6ki2wqDE_fWQ9H3batzmYi5NiPpIrqSlyA1-xnxl9h7VCj8ORZ45uFAFhKvluIeEMjz9C-tGljNm3GyW-Na4viFK4w36Y1H1t1-rhclrVXuNkMB8wk8AHJAeYad_ek7JcrbRGYVy4rbDMGGOjDR-aDKwtK_zZwK4XAWXd6OiZkBmJtsKXv9rRDtbV9UFj4TAnqI'
    },
  ];

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter cards based on search query
  List<Map<String, String>> get _filteredCards {
    if (_searchQuery.isEmpty) {
      return signCards;
    }
    return signCards.where((card) {
      final title = card['title']!.toLowerCase();
      final category = card['category']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1, // Light blue-green background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                children: [
                  Text(
                    'Dictionary',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: darkBlue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search signs...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: darkBlue.withOpacity(0.6),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: darkBlue.withOpacity(0.6),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            // Results count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${_filteredCards.length} signs found',
                    style: TextStyle(
                      fontSize: 14,
                      color: darkBlue.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _filteredCards.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: darkBlue.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No signs found',
                              style: TextStyle(
                                fontSize: 18,
                                color: darkBlue.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching with different keywords',
                              style: TextStyle(
                                fontSize: 14,
                                color: darkBlue.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredCards.length,
                        itemBuilder: (context, index) {
                          return _buildSignCard(_filteredCards[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSignCard(Map<String, String> card) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: darkBlue.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: darkBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(card['imageUrl']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Text Content
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card['title']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  card['category']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}