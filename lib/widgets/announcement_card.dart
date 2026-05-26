import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.campaign, size: 18, color: theme.colorScheme.primary),
                SizedBox(width: 8),
                Text(
                  'Announcement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat('MMM d, HH:mm').format(announcement.createdAt),
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(announcement.content, style: TextStyle(fontSize: 14)),
            SizedBox(height: 6),
            Text(
              '— ${announcement.teacherName}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
