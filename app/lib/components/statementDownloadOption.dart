import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app/main.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StatementDownloadOption extends StatelessWidget {
  const StatementDownloadOption(
      {super.key,
      required this.date,
      required this.billNumber,
      required this.token,
      required this.baseUrl});
  final DateTime date;
  final String billNumber;
  final String token;
  final String baseUrl;

  Future<void> showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'File Downloads',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Statement Downloaded: ${DateFormat('MMMM-yyyy').format(date)}',
      'Tap to open the file',
      platformChannelSpecifics,
      payload: filePath, // The file path as payload
    );
  }

  Future<void> downloadFile({
    required String url,
    required String fileName,
    required void Function(String path) onDownloadCompleted,
    required void Function(String error) onDownloadError,
  }) async {
    try {
      // Request storage permissions (needed for Android)
      final permissionStatus = await Permission.storage.status;
      if (permissionStatus.isDenied) {
        var result = await Permission.storage.request();
        if (result.isDenied) {
          onDownloadError("Storage permission denied.");
          return;
        }
      } else if (permissionStatus.isPermanentlyDenied) {
        onDownloadError("Permission Denied Permanently.");
        return;
      }
      // Fetch the file
      final response = await http.get(Uri.parse(url));

      // Check for a successful response
      if (response.statusCode == 200) {
        // Get the Downloads directory
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory(
              '/storage/emulated/0/Download'); // Android Downloads directory
        } else if (Platform.isIOS) {
          directory =
              await getApplicationDocumentsDirectory(); // iOS app directory
        }

        if (directory == null) {
          onDownloadError("Unable to access the directory");
          return;
        }

        // Construct file path
        final filePath = '${directory.path}/$fileName';

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("File downloaded to $filePath");

        // Notify about the completion
        onDownloadCompleted(filePath);
      } else {
        final error = "Failed to download file: ${response.reasonPhrase}";
        print(error);

        // Notify about the error
        onDownloadError(error);
      }
    } catch (e) {
      final error = "Error downloading file: $e";
      print(error);

      // Notify about the error
      onDownloadError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy').format(date),
                style: GoogleFonts.inter(
                    color: const Color(0xFFA5A9AC), fontSize: 15.0),
              ),
              Text(
                "Statement ready for download",
                style: GoogleFonts.inter(
                    color: const Color(0xFF64788D), fontSize: 12.0),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              print("$baseUrl/meters/statement/$token/$billNumber");
              SnackBarDisplay snackBarDisplay =
                  SnackBarDisplay(context: context);
              downloadFile(
                  url: "$baseUrl/meters/statement/$token/$billNumber",
                  fileName:
                      "Statement-${date.year}-${date.month}-${date.day}-${DateTime.now().day}${DateTime.now().hour}${DateTime.now().second}.pdf",
                  onDownloadCompleted: (String path) {
                    showDownloadNotification(path);
                    print(path);
                    snackBarDisplay
                        .showSuccess("Statement Downloaded Successfully");
                  },
                  onDownloadError: (String error) {
                    print(error);
                    snackBarDisplay.showError("Error $error");
                  });
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(const Color(0xFF243647))),
            child: Text(
              "Download",
              style: GoogleFonts.inter(color: const Color(0xFF9CA4AC)),
            ),
          )
        ],
      ),
    );
  }
}
