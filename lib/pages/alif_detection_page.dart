import 'package:flutter/material.dart';

class AlifDetectionPage extends StatelessWidget {
  const AlifDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection'),
        backgroundColor: const Color.fromARGB(255, 8, 4, 84),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'App is Working! ✅',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Build successful at: ${DateTime.now()}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isModelLoaded ? Colors.green : Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isModelLoaded ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              _isModelLoaded 
                  ? '✅ Model Ready - Detecting hands' 
                  : '⏳ Loading model...',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Landmarks
class LandmarkPainter extends CustomPainter {
  final List<dynamic> landmarks;
  
  LandmarkPainter({required this.landmarks});

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;
    
    final connectionPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Hand connections
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [0, 5], [5, 6], [6, 7], [7, 8],
      [0, 9], [9, 10], [10, 11], [11, 12],
      [0, 13], [13, 14], [14, 15], [15, 16],
      [0, 17], [17, 18], [18, 19], [19, 20],
      [5, 9], [9, 13], [13, 17],
    ];
    
    // Draw connections
    for (var connection in connections) {
      if (connection[0] < landmarks.length && connection[1] < landmarks.length) {
        final p1 = landmarks[connection[0]];
        final p2 = landmarks[connection[1]];
        canvas.drawLine(
          Offset(p1['x'] * size.width, p1['y'] * size.height),
          Offset(p2['x'] * size.width, p2['y'] * size.height),
          connectionPaint,
        );
      }
    }
    
    // Draw landmarks
    for (int i = 0; i < landmarks.length; i++) {
      final landmark = landmarks[i];
      final dx = landmark['x'] * size.width;
      final dy = landmark['y'] * size.height;
      
      Paint paint;
      if ([4, 8, 12, 16, 20].contains(i)) {
        paint = Paint()..color = Colors.yellow..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 8, paint);
      } else if ([0].contains(i)) {
        paint = Paint()..color = Colors.red..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 6, paint);
      } else if ([2, 6, 10, 14, 18].contains(i)) {
        paint = Paint()..color = Colors.orange..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 5, paint);
      } else {
        paint = Paint()..color = Colors.green..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), 4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}