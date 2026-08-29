import 'package:flutter/material.dart';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  // Colors matching your app
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  // Search query
  String _searchQuery = '';

  // ✅ COMMON SIGNS LIST
  final List<Map<String, dynamic>> _signs = [
    {
      'name': 'Hello',
      'image': 'assets/images/sign_hello.png',
      'category': 'Greetings',
      'description': 'Wave your hand near your head',
    },
    {
      'name': 'Thank You',
      'image': 'assets/images/sign_thankyou.png',
      'category': 'Greetings',
      'description': 'Touch your chin with fingertips and move forward',
    },
    {
      'name': 'Sorry',
      'image': 'assets/images/sign_sorry.png',
      'category': 'Emotions',
      'description': 'Make a fist and circle over your chest',
    },
    {
      'name': 'Yes',
      'image': 'assets/images/sign_yes.png',
      'category': 'Basic',
      'description': 'Make a fist and nod your head up and down',
    },
    {
      'name': 'No',
      'image': 'assets/images/sign_no.png',
      'category': 'Basic',
      'description': 'Shake your head or tap index and middle fingers',
    },
    {
      'name': 'Help',
      'image': 'assets/images/sign_help.png',
      'category': 'Emergency',
      'description': 'Place one hand on top of the other and lift up',
    },
    {
      'name': 'Please',
      'image': 'assets/images/sign_please.png',
      'category': 'Basic',
      'description': 'Rub your chest in a circular motion',
    },
    {
      'name': 'Good Morning',
      'image': 'assets/images/sign_goodmorning.png',
      'category': 'Greetings',
      'description': 'Place hand on chest and move outward',
    },
    {
      'name': 'Good Night',
      'image': 'assets/images/sign_goodnight.png',
      'category': 'Greetings',
      'description': 'Place hand on chin and move downward',
    },
    {
      'name': 'Friend',
      'image': 'assets/images/sign_friend.png',
      'category': 'Relationships',
      'description': 'Interlock index fingers and twist',
    },
    {
      'name': 'Family',
      'image': 'assets/images/sign_family.png',
      'category': 'Relationships',
      'description': 'Circle both hands in front of chest',
    },
    {
      'name': 'Eat',
      'image': 'assets/images/sign_eat.png',
      'category': 'Basic',
      'description': 'Tap fingers to mouth',
    },
    {
      'name': 'Drink',
      'image': 'assets/images/sign_drink.png',
      'category': 'Basic',
      'description': 'Make C shape and tilt toward mouth',
    },
    {
      'name': 'Happy',
      'image': 'assets/images/sign_happy.png',
      'category': 'Emotions',
      'description': 'Pat chest with flat hand',
    },
    {
      'name': 'Sad',
      'image': 'assets/images/sign_sad.png',
      'category': 'Emotions',
      'description': 'Draw a tear down your cheek',
    },
  ];

  // Get unique categories for filter
  List<String> get _categories {
    final categories = _signs.map((sign) => sign['category'] as String).toList();
    return categories.toSet().toList();
  }

  String _selectedCategory = 'All';

  // Filtered signs based on search and category
  List<Map<String, dynamic>> get _filteredSigns {
    return _signs.where((sign) {
      final matchesSearch = _searchQuery.isEmpty ||
          sign['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' ||
          sign['category'] == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
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
              // App Bar
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
                      'Common Signs',
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Welcome Text
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Text(
                  'Learn Common Sign Language Signs',
                  style: TextStyle(
                    color: marineBlue.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Search Bar
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
                      hintText: 'Search signs...',
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

              // Category Filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length + 1,
                  itemBuilder: (context, index) {
                    final category = index == 0 ? 'All' : _categories[index - 1];
                    final isSelected = _selectedCategory == category;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : marineBlue,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.white.withOpacity(0.7),
                        selectedColor: lightBlue,
                        side: BorderSide(
                          color: isSelected ? lightBlue : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Signs Grid
              Expanded(
                child: _filteredSigns.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No signs found',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredSigns.length,
                          itemBuilder: (context, index) {
                            final sign = _filteredSigns[index];
                            return _buildSignCard(sign);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignCard(Map<String, dynamic> sign) {
    return GestureDetector(
      onTap: () {
        _showSignDetail(sign);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Sign Image - Size Controlled with SizedBox
            SizedBox(
              height: 110,  // 👈 IMAGE HEIGHT FIXED (kam kiya)
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildImage(sign['image']),
              ),
            ),
            // Sign Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sign['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: marineBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sign['category'],
                      style: TextStyle(
                        fontSize: 10,
                        color: lightBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,  // ✅ 'cover' se 'contain' kiya taake puri image dikhe
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 30,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 4),
              Text(
                'No Image',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSignDetail(Map<String, dynamic> sign) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // ✅ Detail Image - Size Controlled
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  sign['image'],
                  height: 160,  // 👈 DETAIL IMAGE SIZE (kam kiya)
                  width: double.infinity,
                  fit: BoxFit.contain,  // ✅ 'cover' se 'contain' kiya
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                sign['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: marineBlue,
                ),
              ),
              const SizedBox(height: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sign['category'],
                  style: TextStyle(
                    color: lightBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sign['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}