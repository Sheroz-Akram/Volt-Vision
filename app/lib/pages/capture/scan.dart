import 'package:app/components/button.dart';
import 'package:app/components/progressBar.dart';
import 'package:app/components/tip.dart';
import 'package:app/pages/capture/process.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ScanPage();
  }
}

class _ScanPage extends State<ScanPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitializeCamera();
  }

  Future<void> _checkPermissionsAndInitializeCamera() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      _initializeCamera();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Camera Permission"),
          content: const Text("Camera access is required to use this feature."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        ),
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => isCameraInitialized = true);
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/images/logo.png"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Scan your meter",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Hold your phone close to the meter and move it around until you see a green frame.",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(0xFF1A2632),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: isCameraInitialized
                    ? CameraPreview(_cameraController!)
                    : Center(
                        child: Text(
                          "No Camera",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
              ),
              const Tip(
                title: 'Capture the entire dial',
                description:
                    'Make sure there are no shadows,reflections or glares on the screen.',
                tipImage: 'assets/images/tip01.png',
                tipNo: 1,
                totalTips: 3,
              ),
              const ProgressBar(
                percentage: 0.62,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Button(
            buttonText: "Start Scanning",
            onButtonClick: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ProcessPage()));
            }),
      ),
    );
  }
}
