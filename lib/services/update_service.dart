import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../models/update_model.dart';

class UpdateService {
  static const _versionUrl =
      'https://raw.githubusercontent.com/nativecodex/student-dashboard/main/version.json';

  Future<UpdateCheckResult> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http
          .get(Uri.parse(_versionUrl))
          .timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        return const UpdateCheckResult(hasUpdate: false);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final latestVersion = data['latest_version'] as String;
      final downloadUrl = data['download_url'] as String;
      final releaseNotes = data['release_notes'] as String;
      final downloadSize = data['download_size'] as String? ?? 'Unknown';

      final info = AppUpdateInfo(
        latestVersion: latestVersion,
        currentVersion: currentVersion,
        downloadUrl: downloadUrl,
        releaseNotes: releaseNotes,
        downloadSize: downloadSize,
      );

      return UpdateCheckResult(hasUpdate: info.hasUpdate, info: info);
    } catch (e) {
      return UpdateCheckResult(hasUpdate: false, error: e.toString());
    }
  }
}
