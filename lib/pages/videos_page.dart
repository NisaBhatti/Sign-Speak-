import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  // Colors matching your app
  static const Color color1 = Color(0xFFCFE8EA);
  static const Color color2 = Color(0xFFACD9D9);
  static const Color marineBlue = Color.fromARGB(255, 8, 4, 84);
  static const Color lightBlue = Color.fromARGB(255, 0, 109, 176);

  // Search query
  String _searchQuery = '';

  // ✅ VIDEOS LIST - YAHAN APNI VIDEOS ADD KAREIN
  final List<Map<String, dynamic>> _videos = [
    {
      'title': 'Sign Language Basics',
      'subtitle': 'Learn basics of sign language',
      'url': 'https://www.youtube.com/watch?v=0FcwzMq4iWg',
      'category': 'Basics',
      'thumbnail': '',
    },
    {
      'title': 'Alphabet Signs A to Z',
      'subtitle': 'Complete alphabets in sign language',
      'url': 'https://www.youtube.com/watch?v=Ld6lsSqU00g',
      'category': 'Alphabets',
      'thumbnail': '',
    },
    {
      'title': 'Common Greetings',
      'subtitle': 'Hello, Thank You, Sorry and more',
      'url': 'https://www.youtube.com/watch?v=YyUS7Aw9aiA',
      'category': 'Greetings',
      'thumbnail': '',
    },
    {
      'title': 'Numbers 1 to 10',
      'subtitle': 'Learn counting in sign language',
      'url': 'https://www.youtube.com/watch?v=jXybuIDFx_k',
      'category': 'Numbers',
      'thumbnail': '',
    },
    {
      'title': 'Family Signs',
      'subtitle': 'Mother, Father, Brother, Sister',
      'url': 'https://www.youtube.com/watch?v=NkrBTZl0vG8',
      'category': 'Family',
      'thumbnail': '',
    },
    {
      'title': 'Daily Conversation',
      'subtitle': 'Common daily use sentences',
      'url': 'https://www.youtube.com/watch?v=_c--P6VRTUo',
      'category': 'Conversation',
      'thumbnail': '',
    },
  ];

  // Filtered videos
  List<Map<String, dynamic>> get _filteredVideos {
    if (_searchQuery.isEmpty) return _videos;
    return _videos.where((video) {
      return video['title']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          video['subtitle']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // 🎬 Video open karne ka method
  Future<void> _openVideo(String url) async {
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Could not open video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                      'Video Tutorials',
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

              // ========== WELCOME TEXT ==========
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Text(
                  'Watch Sign Language Videos',
                  style: TextStyle(
                    color: marineBlue.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                      hintText: 'Search videos...',
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

              // ========== VIDEOS LIST ==========
              Expanded(
                child: _filteredVideos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_library_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No videos found',
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
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _filteredVideos.length,
                        itemBuilder: (context, index) {
                          final video = _filteredVideos[index];
                          return _buildVideoCard(video);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== VIDEO CARD (Matching your app style) ==========
  Widget _buildVideoCard(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () => _openVideo(video['url']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [marineBlue, lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: marineBlue.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Play Icon Circle
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              
              // Video Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      video['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['subtitle'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        video['category'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.open_in_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}