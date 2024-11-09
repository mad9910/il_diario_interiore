import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NextStoryTimer extends StatelessWidget {
  final DateTime nextMonday;

  const NextStoryTimer({Key? key, required this.nextMonday}) : super(key: key);

  String _getRemainingDays() {
    final now = DateTime.now();
    final difference = nextMonday.difference(now).inDays;
    if (difference == 0) return "Oggi";
    if (difference == 1) return "Domani";
    return "Tra $difference giorni";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFF4285F4).withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 20,
            color: Color(0xFF4285F4),
          ),
          SizedBox(width: 8),
          Text(
            'Prossima storia: ${_getRemainingDays()}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
