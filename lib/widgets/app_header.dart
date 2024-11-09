import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF00FF9D)),
              SizedBox(width: 8),
              Icon(Icons.public, color: Color(0xFF4285F4), size: 32),
              SizedBox(width: 8),
              Icon(Icons.track_changes, color: Color(0xFFFF69B4)),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Il Diario dei Viaggi Interiori',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Come una fotografia cattura l\'essenza di un momento, queste pagine catturano l\'essenza del tuo viaggio. Ogni storia è un\'onda nell\'oceano della tua vita, ogni pensiero una stella nella tua costellazione personale.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
