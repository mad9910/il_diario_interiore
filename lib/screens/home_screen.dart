import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/app_header.dart';
import '../widgets/daily_message_card.dart';
import '../widgets/weekly_story_card.dart';
import '../widgets/saved_items_card.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/next_story_timer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppHeader(),
                
                // Bussola Quotidiana
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE3F2FD),
                        Color(0xFFE1BEE7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              child: Icon(
                                Icons.compass_calibration,
                                size: 48,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Bussola Quotidiana',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Piccole stelle che guidano il tuo cammino ogni giorno',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (appState.currentMessage != null)
                        DailyMessageCard(
                          message: appState.currentMessage!,
                          state: appState,
                        ),
                    ],
                  ),
                ),

                // Cartolina della Settimana
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFCE4EC),
                        Color(0xFFFFF3E0),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.photo_camera, 
                                 size: 48, 
                                 color: Color(0xFFFF69B4)),
                            Text(
                              'Cartolina della Settimana',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'Un messaggio speciale da un nuovo angolo del tuo viaggio',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (appState.currentStory == null)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: NextStoryTimer(
                            nextMonday: DateTime.now().add(
                              Duration(
                                days: 7 - DateTime.now().weekday + 1,
                              ),
                            ),
                          ),
                        ),
                      if (appState.currentStory != null)
                        WeeklyStoryCard(
                          story: appState.currentStory!,
                          state: appState,
                        ),
                    ],
                  ),
                ),

                // Sezione Ricordi Salvati
                SavedItemsCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}
