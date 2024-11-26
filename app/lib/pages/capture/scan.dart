import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/classes/network.dart';
import 'package:app/components/input.dart';
import 'package:app/pages/capture/process.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:app/components/button.dart';
import 'package:app/components/progressBar.dart';
import 'package:app/components/tip.dart';
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
  File? captureImage;
  double progress = 0.0;
  Storage storage = Storage();

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

  Future<void> capture() async {
    if (!_cameraController!.value.isInitialized) return;

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      setState(() {
        captureImage = File(imageFile.path);
      });
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  void showInputReadingDialog(
      BuildContext context, int readingValue, String filePath) {
    TextEditingController readingController = TextEditingController();
    readingController.text = readingValue.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF121A21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Reading Detected',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextInput(
                    hintText: "Detected Reading",
                    controller: readingController),
                const SizedBox(height: 20),
                Button(
                    buttonText: "Submit",
                    onButtonClick: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProcessPage(
                                        meterReading: readingController.text,
                                        filePath: filePath,
                                      )))
                        })
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadImage() async {
    if (captureImage == null) return;
    Network network = Network();
    setState(() {
      progress = 0.0;
    });
    EasyLoading.show(status: "Processing");
    final uri = Uri.parse("${network.baseUrl}/meters/upload");
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', captureImage!.path));

    final http.StreamedResponse response = await request.send();
    List<int> responseData = [];

    response.stream.transform(StreamTransformer.fromHandlers(
      handleData: (chunk, sink) {
        responseData.addAll(chunk);
        setState(() {
          progress = (responseData.length / response.contentLength!);
        });
        sink.add(chunk);
      },
    )).listen((_) {}, onDone: () async {
      final responseString = utf8.decode(responseData);
      try {
        Map<String, dynamic> jsonResponse = jsonDecode(responseString);
        if (jsonResponse['success'] == true) {
          showInputReadingDialog(
              context, jsonResponse['readingValue'], jsonResponse['filePath']);
          EasyLoading.showSuccess(jsonResponse['message']);
        } else {
          SnackBarDisplay(context: context).showError(jsonResponse['message']);
          EasyLoading.showError(jsonResponse['message']);
          setState(() {
            captureImage = null;
          });
        }
      } catch (e) {
        SnackBarDisplay(context: context).showError("Network/Invalid Request");
        EasyLoading.showError("Network/Invalid Request");
        setState(() {
          captureImage = null;
        });
      }
    });
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
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Scan your meter",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "Hold your phone close to the meter and click on Start Scanning button.",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showInputReadingDialog(context, 0, "");
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF243647))),
                      child: Text(
                        "Manual",
                        style:
                            GoogleFonts.inter(color: const Color(0xFF9CA4AC)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(0xFF1A2632),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: isCameraInitialized
                    ? captureImage == null
                        ? CameraPreview(_cameraController!)
                        : Image.file(captureImage!)
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
              ProgressBar(
                percentage: progress,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Button(
              buttonText: "Start Scanning",
              onButtonClick: () async {
                if (captureImage == null) {
                  await capture();
                  await uploadImage();
                }
              })),
    );
  }
}
