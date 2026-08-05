import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class UpdateService {
  // TODO: Swap this placeholder out for your client's real server address
  static const String versionJsonUrl =
      'http://192.168.100.39:5136/api/version/latest';

  static Future<void> checkAndExecuteUpdate(BuildContext context) async {
    try {
      // 1. Read current installed version from device
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentBuildNumber = int.parse(packageInfo.buildNumber);

      // 2. Query the metadata JSON file on the private HTTP endpoint
      final response = await http.get(Uri.parse(versionJsonUrl));
      if (response.statusCode != 200) return;

      final serverData = json.decode(response.body);
      int latestBuildNumber = serverData['buildNumber'];
      String apkDownloadUrl = serverData['apkUrl'];

      // 3. Compare values. If server's build number is higher, launch update sequence
      if (latestBuildNumber > currentBuildNumber) {
        if (!context.mounted) return;
        _showUpdateDialog(context, apkDownloadUrl);
      }
    } catch (e) {
      debugPrint("Failed to execute background OTA check: $e");
    }
  }

  static void _showUpdateDialog(BuildContext context, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Application Update Available"),
        content: const Text(
            "A mandatory system update is ready. The app will now download and install the new version."),
        actions: [
          TextButton(
            child: const Text("Update Now"),
            onPressed: () {
              Navigator.pop(context);
              _startUpdate(downloadUrl);
            },
          )
        ],
      ),
    );
  }

  static Future<void> _startUpdate(String url) async {
    debugPrint('>>> _startUpdate called with url: $url');
    try {
      final dir = await getExternalStorageDirectory();
      debugPrint('>>> Got directory: ${dir?.path}');
      final savePath = '${dir!.path}/app-release.apk';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          debugPrint('>>> progress: $received / $total');
        },
      );
      debugPrint('>>> Download complete, opening file');

      final result = await OpenFilex.open(savePath);
      debugPrint('>>> OTA install result: ${result.type} - ${result.message}');
    } catch (e) {
      debugPrint('>>> Critically failed to initialize update: $e');
    }
  }
}
