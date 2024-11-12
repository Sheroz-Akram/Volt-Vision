import 'package:app/main.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatementDownloadOption extends StatelessWidget {
  const StatementDownloadOption({super.key, required this.date});
  final DateTime date;

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
              SnackBarDisplay snackBarDisplay =
                  SnackBarDisplay(context: context);
              FileDownloader.downloadFile(
                  url:
                      "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                  name: "Statement-${date.year}-${date.month}-${date.day}",
                  onDownloadCompleted: (String path) {
                    showDownloadNotification(path);
                    snackBarDisplay
                        .showSuccess("Statement Downloaded Successfully");
                  },
                  onDownloadError: (String error) {
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
