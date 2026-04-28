import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

/// LiveCameraPage: minimal live camera preview used by the app.
class LiveCameraPage extends StatefulWidget {
  const LiveCameraPage({super.key});

  @override
  State<LiveCameraPage> createState() => _LiveCameraPageState();
}

class _LiveCameraPageState extends State<LiveCameraPage> {
  CameraController? _controller;
  bool _initialized = false;

  // Updated color palette from file
  static const Color color1 = Color(0xFFCFE8EA);   // #cfe8ea - Light blue-green
  static const Color darkBlue = Color.fromARGB(255, 25, 19, 132); // dark Blue

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // create controller locally first
        final controller = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await controller.initialize();

        // If the widget was removed while initializing, dispose the controller and exit.
        if (!mounted) {
          await controller.dispose();
          return;
        }

        // assign and update state once initialized
        setState(() {
          _controller = controller;
          _initialized = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No cameras available')),
          );
        }
      }
    } on MissingPluginException catch (e) {
      // Plugin not registered (common after hot-reload). Advise full restart.
      // ignore: avoid_print
      print('LiveCamera plugin error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Camera plugin not registered — perform a full restart',
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('LiveCamera init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera init error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Camera'),
        backgroundColor: darkBlue, // Marine Blue
        foregroundColor: Colors.white,
      ),
      backgroundColor: color1, // Light blue-green background
      body: _initialized && _controller != null
          ? CameraPreview(_controller!)
          : Center(
              child: CircularProgressIndicator(
                color: darkBlue, // Marine Blue loading indicator
              ),
            ),
    );
  }
}