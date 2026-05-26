import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/timetable_model.dart';

class TimetableCard extends StatelessWidget {
  final TimetableEvent event;

  const TimetableCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFmt = DateFormat('HH:mm');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: event.isShifted
            ? BorderSide(color: Colors.amber.shade400, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Lesson ${event.lessonId}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (event.isShifted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'SHIFTED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'CONFIRMED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            if (!event.isShifted) ...[
              _row(Icons.access_time, timeFmt.format(event.currentTime)),
              if (event.roomLocation.isNotEmpty)
                _row(Icons.room, event.roomLocation),
            ] else ...[
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.red.shade400),
                  SizedBox(width: 6),
                  Text(
                    timeFmt.format(event.originalTime),
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red.shade300,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    timeFmt.format(event.currentTime),
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              _row(
                Icons.room,
                event.roomLocation,
                iconColor: Colors.orange,
              ),
              if (event.shiftReason != null) ...[
                SizedBox(height: 4),
                _row(
                  Icons.info_outline,
                  event.shiftReason!,
                  iconColor: Colors.orange,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text, {Color? iconColor}) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor ?? Colors.grey),
          SizedBox(width: 6),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
