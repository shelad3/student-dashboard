import 'package:flutter/material.dart';

class ShiftBadge extends StatelessWidget {
  final bool isShifted;

  const ShiftBadge({super.key, required this.isShifted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isShifted
            ? Colors.orange.shade100
            : Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isShifted ? 'Shifted' : 'Confirmed',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isShifted ? Colors.orange.shade800 : Colors.green.shade800,
        ),
      ),
    );
  }
}
