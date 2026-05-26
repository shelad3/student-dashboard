import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/update_model.dart';

class UpdateDialog extends StatelessWidget {
  final AppUpdateInfo info;

  const UpdateDialog({super.key, required this.info});

  Future<void> _download(BuildContext context) async {
    final uri = Uri.tryParse(info.downloadUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.system_update, color: theme.colorScheme.primary),
          SizedBox(width: 8),
          Text('Update Available'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  Icons.info_outline,
                  'Version: ${info.currentVersion} → ${info.latestVersion}',
                ),
                SizedBox(height: 4),
                _infoRow(Icons.storage, 'Size: ${info.downloadSize}'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'What\'s new:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 180),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Text(
                info.releaseNotes,
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Later'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context, true);
            _download(context);
          },
          icon: Icon(Icons.download),
          label: Text('Download Update'),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 13)),
      ],
    );
  }
}
