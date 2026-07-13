import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

// ✅ Platform-specific imports
import 'package:tflite_flutter/tflite_flutter.dart' 
    if (dart.library.html) 'package:tflite_flutter/tflite_flutter_web.dart';

class AlifDetectionPage extends StatefulWidget {
  const AlifDetectionPage({super.key});

  @override
  State<AlifDetectionPage> createState() => _AlifDetectionPageState();
}

class _AlifDetectionPageState extends State<AlifDetectionPage> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  bool _isCameraReady = false;
  String _prediction = 'Waiting for input...';
  double _confidence = 0.0;
  List<CameraDescription>? _cameras;

  final int _inputSize = 224;
  final int _numClasses = 10;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _loadModel();
    await _initCamera();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await [
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }

  Future<void> _loadModel() async {
    try {
      print('📥 Loading model...');
      
      // ✅ Different loading for Windows vs Mobile
      if (Platform.isWindows) {
        // For Windows: Load from local file
        final dir = await getApplicationDocumentsDirectory();
        final modelPath = '${dir.path}/alif_model.tflite';
        
        // Copy from assets to local storage
        // (You'll need to pre-copy the model file)
        _interpreter = Interpreter.fromFile(File(modelPath));
      } else {
        // For Mobile: Load from assets
        _interpreter = await Interpreter.fromAsset(
          'assets/models/alif_model.tflite',
          options: InterpreterOptions()..threads = 4,
        );
      }
      
      setState(() {
        _isModelLoaded = true;
      });
      print('✅ Model loaded successfully!');
    } catch (e) {
      print('❌ Failed to load model: $e');
      // ✅ Use fallback prediction for Windows testing
      if (Platform.isWindows) {
        setState(() {
          _isModelLoaded = true; // Allow testing UI
          _prediction = 'Alif (Demo)';
        });
      }
    }
  }

  Future<void> _initCamera() async {
    try {
      // ✅ Skip camera on Windows for now
      if (Platform.isWindows) {
        setState(() {
          _isCameraReady = true;
        });
        print('✅ Windows: Camera simulation mode');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      
      setState(() {
        _isCameraReady = true;
      });
      print('✅ Camera initialized!');
    } catch (e) {
      print('❌ Camera initialization failed: $e');
      // ✅ Fallback for Windows
      if (Platform.isWindows) {
        setState(() {
          _isCameraReady = true;
        });
      }
    }
  }

  // ✅ Mock prediction for Windows testing
  Future<void> _simulatePrediction() async {
    setState(() {
      _prediction = 'الف';
      _confidence = 0.92;
    });
  }

  Future<void> _captureAndPredict() async {
    if (!_isCameraReady || !_isModelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera or model not ready!')),
      );
      return;
    }

    // ✅ Windows simulation
    if (Platform.isWindows) {
      await _simulatePrediction();
      return;
    }

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final File image = File(imageFile.path);
      
      final img.Image? inputImage = img.decodeImage(await image.readAsBytes());
      if (inputImage == null) throw Exception('Failed to decode image');

      final preprocessed = _preprocessImage(inputImage);
      final output = await _runInference(preprocessed);
      final (predictedClass, confidence) = _getPrediction(output);
      
      setState(() {
        _prediction = _getSignLabel(predictedClass);
        _confidence = confidence;
      });
      
      print('🎯 Prediction: $_prediction (${(confidence * 100).toStringAsFixed(1)}%)');
    } catch (e) {
      print('❌ Prediction error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  List<List<double>> _preprocessImage(img.Image image) {
    final resized = img.copyResize(image, width: _inputSize, height: _inputSize);
    
    List<List<double>> input = List.generate(
      _inputSize,
      (y) => List.generate(
        _inputSize,
        (x) {
          final pixel = resized.getPixel(x, y);
          return (pixel.r + pixel.g + pixel.b) / (3 * 255.0);
        },
      ),
    );
    
    return input;
  }

  Future<List<List<double>>> _runInference(List<List<double>> input) async {
    var inputTensor = [input];
    var outputTensor = List.generate(
      1,
      (i) => List.generate(_numClasses, (j) => 0.0),
    );
    
    _interpreter?.run(inputTensor, outputTensor);
    return outputTensor;
  }

  (int, double) _getPrediction(List<List<double>> output) {
    final predictions = output[0];
    int maxIndex = 0;
    double maxValue = predictions[0];
    
    for (int i = 1; i < predictions.length; i++) {
      if (predictions[i] > maxValue) {
        maxValue = predictions[i];
        maxIndex = i;
      }
    }
    
    return (maxIndex, maxValue);
  }

  String _getSignLabel(int index) {
    const labels = [
      'الف', 'بے', 'پے', 'تے', 'ٹے', 
      'ثے', 'جیم', 'چے', 'حے', 'خے'
    ];
    
    if (index < labels.length) {
      return labels[index];
    }
    return 'Unknown';
  }

  Future<void> _pickImageAndPredict() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (imageFile == null) return;
    
    try {
      final File image = File(imageFile.path);
      final img.Image? inputImage = img.decodeImage(await image.readAsBytes());
      if (inputImage == null) throw Exception('Failed to decode image');
      
      final preprocessed = _preprocessImage(inputImage);
      final output = await _runInference(preprocessed);
      final (predictedClass, confidence) = _getPrediction(output);
      
      setState(() {
        _prediction = _getSignLabel(predictedClass);
        _confidence = confidence;
      });
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alif Detection - Urdu Sign Language'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: _isCameraReady
                  ? _cameraController != null && _cameraController!.value.isInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CameraPreview(_cameraController!),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Camera Preview', style: TextStyle(color: Colors.grey)),
                              Text('(Windows: Simulation Mode)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  'Detection Result',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _prediction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_confidence > 0)
                  Text(
                    '${(_confidence * 100).toStringAsFixed(1)}% confidence',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isCameraReady && _isModelLoaded
                        ? _captureAndPredict
                        : null,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(Platform.isWindows ? 'Simulate' : 'Capture & Detect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isModelLoaded ? _pickImageAndPredict : null,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isModelLoaded ? Icons.check_circle : Icons.warning,
                  color: _isModelLoaded ? Colors.green : Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _isModelLoaded ? 'Model Ready' : 'Loading Model...',
                  style: TextStyle(
                    color: _isModelLoaded ? Colors.green : Colors.orange,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Platform.isWindows ? '💻 Windows' : '📱 Mobile',
                    style: const TextStyle(fontSize: 10),
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