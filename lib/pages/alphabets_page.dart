import 'package:flutter/material.dart';

class AlphabetsPage extends StatefulWidget {
  const AlphabetsPage({super.key});

  @override
  State<AlphabetsPage> createState() => _AlphabetsPageState();
}

class _AlphabetsPageState extends State<AlphabetsPage> {
  // Colors matching your app
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  // Search query
  String _searchQuery = '';

  // Selected tab: 'english' or 'urdu'
  String _selectedTab = 'english';

  // English Alphabets with Sign Images
  final List<Map<String, dynamic>> _englishAlphabets = [
    {'letter': 'A', 'image': 'assets/images/sign_a.png', 'description': 'Make a fist with thumb on side'},
    {'letter': 'B', 'image': 'assets/images/sign_b.png', 'description': 'Keep fingers straight and together'},
    {'letter': 'C', 'image': 'assets/images/sign_c.png', 'description': 'Curve hand into C shape'},
    {'letter': 'D', 'image': 'assets/images/sign_d.png', 'description': 'Index finger up, thumb touches fingertips'},
    {'letter': 'E', 'image': 'assets/images/sign_e.png', 'description': 'Bend fingers down over thumb'},
    {'letter': 'F', 'image': 'assets/images/sign_f.png', 'description': 'Index and thumb touch, other fingers up'},
    {'letter': 'G', 'image': 'assets/images/sign_g.png', 'description': 'Index finger pointing sideways'},
    {'letter': 'H', 'image': 'assets/images/sign_h.png', 'description': 'Index and middle fingers together sideways'},
    {'letter': 'I', 'image': 'assets/images/sign_i.png', 'description': 'Pinky finger up, thumb across palm'},
    {'letter': 'J', 'image': 'assets/images/sign_j.png', 'description': 'Pinky finger drawing J shape'},
    {'letter': 'K', 'image': 'assets/images/sign_k.png', 'description': 'Index and middle up, thumb between'},
    {'letter': 'L', 'image': 'assets/images/sign_l.png', 'description': 'Index finger up, thumb sideways'},
    {'letter': 'M', 'image': 'assets/images/sign_m.png', 'description': 'Three fingers over thumb'},
    {'letter': 'N', 'image': 'assets/images/sign_n.png', 'description': 'Two fingers over thumb'},
    {'letter': 'O', 'image': 'assets/images/sign_o.png', 'description': 'Fingers curved into O shape'},
    {'letter': 'P', 'image': 'assets/images/sign_p.png', 'description': 'Index and middle down, thumb between'},
    {'letter': 'Q', 'image': 'assets/images/sign_q.png', 'description': 'Index and thumb pointing down'},
    {'letter': 'R', 'image': 'assets/images/sign_r.png', 'description': 'Index and middle crossed'},
    {'letter': 'S', 'image': 'assets/images/sign_s.png', 'description': 'Make a fist with thumb in front'},
    {'letter': 'T', 'image': 'assets/images/sign_t.png', 'description': 'Thumb between index and middle'},
    {'letter': 'U', 'image': 'assets/images/sign_u.png', 'description': 'Index and middle up together'},
    {'letter': 'V', 'image': 'assets/images/sign_v.png', 'description': 'Index and middle up in V shape'},
    {'letter': 'W', 'image': 'assets/images/sign_w.png', 'description': 'Three fingers up in W shape'},
    {'letter': 'X', 'image': 'assets/images/sign_x.png', 'description': 'Index finger bent like hook'},
    {'letter': 'Y', 'image': 'assets/images/sign_y.png', 'description': 'Pinky and thumb out'},
    {'letter': 'Z', 'image': 'assets/images/sign_z.png', 'description': 'Index finger drawing Z shape'},
  ];

  // Urdu Alphabets (الف تا یئ) with Sign Images
  final List<Map<String, dynamic>> _urduAlphabets = [
    {'letter': 'ا', 'image': 'assets/images/sign_alif.png', 'description': 'Alif - Straight line sign'},
    {'letter': 'ب', 'image': 'assets/images/sign_bay.png', 'description': 'Bay - Dot below sign'},
    {'letter': 'پ', 'image': 'assets/images/sign_pay.png', 'description': 'Pay - Three dots sign'},
    {'letter': 'ت', 'image': 'assets/images/sign_tay.png', 'description': 'Tay - Two dots sign'},
    {'letter': 'ٹ', 'image': 'assets/images/sign_tay_urdu.png', 'description': 'Tay Urdu - Unique sign'},
    {'letter': 'ث', 'image': 'assets/images/sign_say.png', 'description': 'Say - Three dots sign'},
    {'letter': 'ج', 'image': 'assets/images/sign_jeem.png', 'description': 'Jeem - Curved sign'},
    {'letter': 'چ', 'image': 'assets/images/sign_chey.png', 'description': 'Chey - Three dots sign'},
    {'letter': 'ح', 'image': 'assets/images/sign_hay.png', 'description': 'Hay - Round sign'},
    {'letter': 'خ', 'image': 'assets/images/sign_khay.png', 'description': 'Khay - Dot above sign'},
    {'letter': 'د', 'image': 'assets/images/sign_daal.png', 'description': 'Daal - Straight sign'},
    {'letter': 'ڈ', 'image': 'assets/images/sign_daal_urdu.png', 'description': 'Daal Urdu - Unique sign'},
    {'letter': 'ذ', 'image': 'assets/images/sign_zaal.png', 'description': 'Zaal - Dot above sign'},
    {'letter': 'ر', 'image': 'assets/images/sign_ray.png', 'description': 'Ray - Curved sign'},
    {'letter': 'ڑ', 'image': 'assets/images/sign_ray_urdu.png', 'description': 'Ray Urdu - Unique sign'},
    {'letter': 'ز', 'image': 'assets/images/sign_zay.png', 'description': 'Zay - Dot above sign'},
    {'letter': 'ژ', 'image': 'assets/images/sign_zhe.png', 'description': 'Zhe - Three dots sign'},
    {'letter': 'س', 'image': 'assets/images/sign_seen.png', 'description': 'Seen - Tooth shape sign'},
    {'letter': 'ش', 'image': 'assets/images/sign_sheen.png', 'description': 'Sheen - Three dots sign'},
    {'letter': 'ص', 'image': 'assets/images/sign_suad.png', 'description': 'Suad - Heavy sign'},
    {'letter': 'ض', 'image': 'assets/images/sign_zuad.png', 'description': 'Zuad - Heavy sign'},
    {'letter': 'ط', 'image': 'assets/images/sign_toay.png', 'description': 'Toay - Heavy sign'},
    {'letter': 'ظ', 'image': 'assets/images/sign_zoay.png', 'description': 'Zoay - Heavy sign'},
    {'letter': 'ع', 'image': 'assets/images/sign_ayn.png', 'description': 'Ayn - Curved sign'},
    {'letter': 'غ', 'image': 'assets/images/sign_ghayn.png', 'description': 'Ghayn - Curved sign'},
    {'letter': 'ف', 'image': 'assets/images/sign_fay.png', 'description': 'Fay - Dot above sign'},
    {'letter': 'ق', 'image': 'assets/images/sign_qaf.png', 'description': 'Qaf - Two dots sign'},
    {'letter': 'ک', 'image': 'assets/images/sign_kaf.png', 'description': 'Kaf - Urdu Kaf sign'},
    {'letter': 'گ', 'image': 'assets/images/sign_gaf.png', 'description': 'Gaf - Urdu Gaf sign'},
    {'letter': 'ل', 'image': 'assets/images/sign_laam.png', 'description': 'Laam - Straight sign'},
    {'letter': 'م', 'image': 'assets/images/sign_meem.png', 'description': 'Meem - Round sign'},
    {'letter': 'ن', 'image': 'assets/images/sign_noon.png', 'description': 'Noon - Dot above sign'},
    {'letter': 'و', 'image': 'assets/images/sign_wao.png', 'description': 'Wao - Curved sign'},
    {'letter': 'ہ', 'image': 'assets/images/sign_he.png', 'description': 'He - Urdu He sign'},
    {'letter': 'ھ', 'image': 'assets/images/sign_he_do.png', 'description': 'He Do - Aspirated sign'},
    {'letter': 'ء', 'image': 'assets/images/sign_hamza.png', 'description': 'Hamza - Glottal stop sign'},
    {'letter': 'ی', 'image': 'assets/images/sign_ye.png', 'description': 'Ye - Urdu Ye sign'},
    {'letter': 'ے', 'image': 'assets/images/sign_bari_ye.png', 'description': 'Bari Ye - Urdu Bari Ye sign'},
  ];

  // Get filtered alphabets based on search
  List<Map<String, dynamic>> get _filteredAlphabets {
    final alphabets = _selectedTab == 'english' ? _englishAlphabets : _urduAlphabets;
    
    if (_searchQuery.isEmpty) return alphabets;
    
    return alphabets.where((item) {
      return item['letter']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
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
                        color: marineBlue.withValues(alpha: 0.1),
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
                      'Alphabets',
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

              // Tabs for English / Urdu
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTabButton('A to Z', 'english'),
                    _buildTabButton('الف تا یئ', 'urdu'),
                  ],
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
                        color: Colors.black.withValues(alpha: 0.05),
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
                      hintText: 'Search alphabets...',
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

              // Alphabets Grid
              Expanded(
                child: _filteredAlphabets.isEmpty
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
                              'No alphabets found',
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
                            crossAxisCount: 3,
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredAlphabets.length,
                          itemBuilder: (context, index) {
                            final alphabet = _filteredAlphabets[index];
                            return _buildAlphabetCard(alphabet);
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

  Widget _buildTabButton(String label, String tabValue) {
    final isSelected = _selectedTab == tabValue;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tabValue;
            _searchQuery = '';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? lightBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : marineBlue,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetCard(Map<String, dynamic> alphabet) {
    return GestureDetector(
      onTap: () {
        _showAlphabetDetail(alphabet);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Alphabet Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildImage(alphabet['image']),
              ),
            ),
            // Alphabet Letter
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                alphabet['letter'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: marineBlue,
                ),
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

  void _showAlphabetDetail(Map<String, dynamic> alphabet) {
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
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // Alphabet Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  alphabet['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
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
              
              // Alphabet Letter
              Text(
                alphabet['letter'],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: marineBlue,
                ),
              ),
              const SizedBox(height: 8),
              
              // Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alphabet['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Close Button
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