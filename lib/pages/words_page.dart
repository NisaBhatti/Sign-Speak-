import 'package:flutter/material.dart';
import '../services/favourite_service.dart';
import '../services/history_service.dart';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  String _searchQuery = '';
  String _selectedCategory = 'All';

  final FavouriteService _favouriteService = FavouriteService();
  final HistoryService _historyService = HistoryService();

  final List<Map<String, dynamic>> _signs = [
    {'name': 'Hello', 'urdu': 'ہیلو', 'image': 'assets/images/sign_hello.png', 'category': 'Greetings', 'description': 'Wave your hand near your head'},
    {'name': 'Thank You', 'urdu': 'شکریہ', 'image': 'assets/images/sign_thankyou.png', 'category': 'Greetings', 'description': 'Touch your chin with fingertips and move forward'},
    {'name': 'Sorry', 'urdu': 'معاف کیجیے', 'image': 'assets/images/sign_sorry.png', 'category': 'Emotions', 'description': 'Make a fist and circle over your chest'},
    {'name': 'Yes', 'urdu': 'جی ہاں', 'image': 'assets/images/sign_yes.png', 'category': 'Basic', 'description': 'Make a fist and nod your head up and down'},
    {'name': 'No', 'urdu': 'نہیں', 'image': 'assets/images/sign_no.png', 'category': 'Basic', 'description': 'Shake your head or tap index and middle fingers'},
    {'name': 'Help', 'urdu': 'مدد', 'image': 'assets/images/sign_help.png', 'category': 'Emergency', 'description': 'Place one hand on top of the other and lift up'},
    {'name': 'Please', 'urdu': 'برائے مہربانی', 'image': 'assets/images/sign_please.png', 'category': 'Basic', 'description': 'Rub your chest in a circular motion'},
    {'name': 'Good Morning', 'urdu': 'صبح بخیر', 'image': 'assets/images/sign_goodmorning.png', 'category': 'Greetings', 'description': 'Place hand on chest and move outward'},
    {'name': 'Good Night', 'urdu': 'شب بخیر', 'image': 'assets/images/sign_goodnight.png', 'category': 'Greetings', 'description': 'Place hand on chin and move downward'},
    {'name': 'Friend', 'urdu': 'دوست', 'image': 'assets/images/sign_friend.png', 'category': 'Relationships', 'description': 'Interlock index fingers and twist'},
    {'name': 'Family', 'urdu': 'خاندان', 'image': 'assets/images/sign_family.png', 'category': 'Relationships', 'description': 'Circle both hands in front of chest'},
    {'name': 'Eat', 'urdu': 'کھانا', 'image': 'assets/images/sign_eat.png', 'category': 'Basic', 'description': 'Tap fingers to mouth'},
    {'name': 'Drink', 'urdu': 'پینا', 'image': 'assets/images/sign_drink.png', 'category': 'Basic', 'description': 'Make C shape and tilt toward mouth'},
    {'name': 'Happy', 'urdu': 'خوش', 'image': 'assets/images/sign_happy.png', 'category': 'Emotions', 'description': 'Pat chest with flat hand'},
    {'name': 'Sad', 'urdu': 'اداس', 'image': 'assets/images/sign_sad.png', 'category': 'Emotions', 'description': 'Draw a tear down your cheek'},
    {'name': 'Mother', 'urdu': 'ماں', 'image': 'assets/images/sign_mother.png', 'category': 'Relationships', 'description': 'Touch thumb to chin with open hand'},
    {'name': 'Father', 'urdu': 'والد', 'image': 'assets/images/sign_father.png', 'category': 'Relationships', 'description': 'Touch thumb to forehead with open hand'},
    {'name': 'Brother', 'urdu': 'بھائی', 'image': 'assets/images/sign_brother.png', 'category': 'Relationships', 'description': 'Bring both hands together at forehead'},
    {'name': 'Sister', 'urdu': 'بہن', 'image': 'assets/images/sign_sister.png', 'category': 'Relationships', 'description': 'Bring both hands together at chin'},
    {'name': 'Water', 'urdu': 'پانی', 'image': 'assets/images/sign_water.png', 'category': 'Basic', 'description': 'Tap chin with W-shaped hand'},
    {'name': 'Food', 'urdu': 'کھانا', 'image': 'assets/images/sign_food.png', 'category': 'Basic', 'description': 'Bring fingers to mouth repeatedly'},
    {'name': 'Home', 'urdu': 'گھر', 'image': 'assets/images/sign_home.png', 'category': 'Places', 'description': 'Bring both hands to your chest'},
    {'name': 'School', 'urdu': 'اسکول', 'image': 'assets/images/sign_school.png', 'category': 'Places', 'description': 'Clap hands together and separate'},
    {'name': 'Hospital', 'urdu': 'ہسپتال', 'image': 'assets/images/sign_hospital.png', 'category': 'Places', 'description': 'Draw a cross on your upper arm'},
    {'name': 'Teacher', 'urdu': 'استاد', 'image': 'assets/images/sign_teacher.png', 'category': 'Education', 'description': 'Touch forehead with fingertips and move outward'},
    {'name': 'Student', 'urdu': 'طالب علم', 'image': 'assets/images/sign_student.png', 'category': 'Education', 'description': 'Flat hand on palm and move to forehead'},
    {'name': 'Book', 'urdu': 'کتاب', 'image': 'assets/images/sign_book.png', 'category': 'Education', 'description': 'Palms together opening like a book'},
    {'name': 'Time', 'urdu': 'وقت', 'image': 'assets/images/sign_time.png', 'category': 'Basic', 'description': 'Tap wrist with index finger'},
    {'name': 'Today', 'urdu': 'آج', 'image': 'assets/images/sign_today.png', 'category': 'Basic', 'description': 'Bring both hands down in front of body'},
    {'name': 'Tomorrow', 'urdu': 'کل', 'image': 'assets/images/sign_tomorrow.png', 'category': 'Basic', 'description': 'Thumb on cheek and move forward'},
    {'name': 'Beautiful', 'urdu': 'خوبصورت', 'image': 'assets/images/sign_beautiful.png', 'category': 'Emotions', 'description': 'Circle hand around face'},
    {'name': 'Angry', 'urdu': 'غصے میں', 'image': 'assets/images/sign_angry.png', 'category': 'Emotions', 'description': 'Claw hand pulled from face'},
    {'name': 'Hungry', 'urdu': 'بھوکا', 'image': 'assets/images/sign_hungry.png', 'category': 'Basic', 'description': 'C-hand slides down chest'},
    {'name': 'Thirsty', 'urdu': 'پیاسا', 'image': 'assets/images/sign_thirsty.png', 'category': 'Basic', 'description': 'Index finger slides down throat'},
    {'name': 'Tired', 'urdu': 'تھکا ہوا', 'image': 'assets/images/sign_tired.png', 'category': 'Emotions', 'description': 'Fingertips on chest with drooping shoulders'},
    {'name': 'Love', 'urdu': 'محبت', 'image': 'assets/images/sign_love.png', 'category': 'Emotions', 'description': 'Cross both arms over your chest'},
    {'name': 'Morning', 'urdu': 'صبح', 'image': 'assets/images/sign_morning.png', 'category': 'Basic', 'description': 'Arm rises like the sun'},
    {'name': 'Night', 'urdu': 'رات', 'image': 'assets/images/sign_night.png', 'category': 'Basic', 'description': 'Bent hand moves over the other arm'},
    {'name': 'Money', 'urdu': 'پیسے', 'image': 'assets/images/sign_money.png', 'category': 'Basic', 'description': 'Tap flat hand on palm'},
    {'name': 'Doctor', 'urdu': 'ڈاکٹر', 'image': 'assets/images/sign_doctor.png', 'category': 'Places', 'description': 'Tap wrist with two fingers'},
    {'name': 'Police', 'urdu': 'پولیس', 'image': 'assets/images/sign_police.png', 'category': 'Emergency', 'description': 'Tap chest with flat hand like a badge'},
    {'name': 'Phone', 'urdu': 'فون', 'image': 'assets/images/sign_phone.png', 'category': 'Basic', 'description': 'Hand shaped like a phone near ear'},
    {'name': 'Car', 'urdu': 'گاڑی', 'image': 'assets/images/sign_car.png', 'category': 'Places', 'description': 'Steering motion with both hands'},
    {'name': 'Work', 'urdu': 'کام', 'image': 'assets/images/sign_work.png', 'category': 'Education', 'description': 'Tap one fist on top of the other'},
    {'name': 'Play', 'urdu': 'کھیلنا', 'image': 'assets/images/sign_play.png', 'category': 'Basic', 'description': 'Shake both hands with Y-shape'},
  ];

  List<String> get _categories {
    final categories = _signs.map((sign) => sign['category'] as String).toList();
    return categories.toSet().toList();
  }

  List<Map<String, dynamic>> get _filteredSigns {
    return _signs.where((sign) {
      final matchesSearch = _searchQuery.isEmpty ||
          sign['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sign['urdu'].toString().contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'All' || sign['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _favouriteService.loadFavourites();
    _historyService.loadHistory();
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
                    Text('Common Signs', style: TextStyle(color: lightBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Text('Learn Common Sign Language Signs', style: TextStyle(color: marineBlue.withOpacity(0.7), fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search signs...',
                      prefixIcon: Icon(Icons.search, color: lightBlue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
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
                        label: Text(category, style: TextStyle(color: isSelected ? Colors.white : marineBlue, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                        selected: isSelected,
                        onSelected: (selected) => setState(() => _selectedCategory = category),
                        backgroundColor: Colors.white.withOpacity(0.7),
                        selectedColor: lightBlue,
                        side: BorderSide(color: isSelected ? lightBlue : Colors.transparent, width: 1),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _filteredSigns.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text('No signs found', style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                            const SizedBox(height: 8),
                            Text('Try adjusting your search', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
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
    final isFav = _favouriteService.isFavourite(sign['name']);

    return GestureDetector(
      onTap: () => _showSignDetail(sign),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.grey.shade100,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _buildImage(sign['image']),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: IconButton(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey, size: 20),
                        onPressed: () async {
                          await _favouriteService.toggleFavourite(sign);
                          
                          await _historyService.addHistory(
                            title: sign['name'] ?? 'Sign',
                            action: 'Favourite',
                            details: isFav ? 'Removed from favourites' : 'Added to favourites',
                          );
                          
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFav ? 'Removed from favourites' : 'Added to favourites'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: isFav ? Colors.red : Colors.green,
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sign['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: marineBlue), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(sign['urdu'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
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
      fit: BoxFit.cover,
      width: double.infinity,
      height: 120,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text('No Image', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  void _showSignDetail(Map<String, dynamic> sign) {
    final isFav = _favouriteService.isFavourite(sign['name']);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      sign['image'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(height: 180, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sign['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: marineBlue)),
                            const SizedBox(height: 4),
                            Text(sign['urdu'], style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey, size: 30),
                        onPressed: () async {
                          await _favouriteService.toggleFavourite(sign);
                          
                          await _historyService.addHistory(
                            title: sign['name'] ?? 'Sign',
                            action: 'Favourite',
                            details: isFav ? 'Removed from favourites' : 'Added to favourites',
                          );
                          
                          setState(() {});
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFav ? 'Removed from favourites' : 'Added to favourites'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: isFav ? Colors.red : Colors.green,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(color: lightBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(sign['category'], style: TextStyle(color: lightBlue, fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text(sign['description'], textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      },
    );
  }
}