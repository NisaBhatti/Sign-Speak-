import 'package:flutter/material.dart';
import '../services/alphabet_detection_service.dart';
import 'alphabet_detection_page.dart';

class AlphabetSelectionPage extends StatefulWidget {
  const AlphabetSelectionPage({Key? key}) : super(key: key);

  @override
  State<AlphabetSelectionPage> createState() => _AlphabetSelectionPageState();
}

class _AlphabetSelectionPageState extends State<AlphabetSelectionPage> {
  List<AlphabetModel> _models = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    final models = await AlphabetDetectionService.getAvailableModels();
    
    if (models.isEmpty) {
      // Fallback: Use predefined list if server is not responding
      _models = _getDefaultModels();
    } else {
      _models = models;
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  List<AlphabetModel> _getDefaultModels() {
    return [
      AlphabetModel(name: 'alif', display: 'Alif', arabic: 'ا'),
      AlphabetModel(name: 'bay', display: 'Bay', arabic: 'ب'),
      AlphabetModel(name: 'tay', display: 'Tay', arabic: 'ت'),
      AlphabetModel(name: 'thay', display: 'Thay', arabic: 'ث'),
      AlphabetModel(name: 'seen', display: 'Seen', arabic: 'س'),
      AlphabetModel(name: 'sheen', display: 'Sheen', arabic: 'ش'),
      AlphabetModel(name: 'suaad', display: 'Suaad', arabic: 'ص'),
      AlphabetModel(name: 'zvad', display: 'Zvad', arabic: 'ض'),
      AlphabetModel(name: 'toayn', display: 'Toayn', arabic: 'ط'),
      AlphabetModel(name: 'zoyn', display: 'Zoyn', arabic: 'ظ'),
      AlphabetModel(name: 'ain', display: 'Ain', arabic: 'ع'),
      AlphabetModel(name: 'ghain', display: 'Ghain', arabic: 'غ'),
      AlphabetModel(name: 'fe', display: 'Fe', arabic: 'ف'),
      AlphabetModel(name: 'quaaf', display: 'Quaaf', arabic: 'ق'),
      AlphabetModel(name: 'kaf', display: 'Kaf', arabic: 'ك'),
      AlphabetModel(name: 'gaf', display: 'Gaf', arabic: 'گ'),
      AlphabetModel(name: 'lam', display: 'Lam', arabic: 'ل'),
      AlphabetModel(name: 'mim', display: 'Mim', arabic: 'م'),
      AlphabetModel(name: 'noon', display: 'Noon', arabic: 'ن'),
      AlphabetModel(name: 'vao', display: 'Vao', arabic: 'و'),
      AlphabetModel(name: 'hamza', display: 'Hamza', arabic: 'ء'),
      AlphabetModel(name: 'choti_ye', display: 'Choti Ye', arabic: 'ی'),
      AlphabetModel(name: 'bari_ye', display: 'Bari Ye', arabic: 'ے'),
      AlphabetModel(name: 'ray', display: 'Ray', arabic: 'ر'),
      AlphabetModel(name: 'rray', display: 'Rray', arabic: 'ڑ'),
      AlphabetModel(name: 'zay', display: 'Zay', arabic: 'ز'),
      AlphabetModel(name: 'dal', display: 'Dal', arabic: 'د'),
      AlphabetModel(name: 'daal', display: 'Daal', arabic: 'ڈ'),
      AlphabetModel(name: 'zal', display: 'Zal', arabic: 'ذ'),
      AlphabetModel(name: 'khay', display: 'Khay', arabic: 'خ'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Select Alphabet'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadModels();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _models.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blueAccent.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            '${_models.length} alphabets available',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _models.length,
                        itemBuilder: (context, index) {
                          final model = _models[index];
                          return _buildAlphabetCard(context, model);
                        },
                      ),
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
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No models available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Make sure Python server is running',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _loadModels();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlphabetCard(BuildContext context, AlphabetModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlphabetDetectionPage(
              alphabet: model.name,
              displayName: model.display,
              arabic: model.arabic,
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
            // Arabic letter
            Text(
              model.arabic,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Display name
            Text(
              model.display,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}