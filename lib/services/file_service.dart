import 'package:flutter/services.dart' show rootBundle;
import '../models/daily_message.dart';
import '../models/weekly_story.dart';

class FileService {
  static Future<List<String>> loadRawMessages() async {
    try {
      final String content = await rootBundle.loadString('assets/messages.txt');
      final RegExp messageRegex = RegExp(r'"([^"]+)"');
      final Iterable<Match> matches = messageRegex.allMatches(content);
      
      return matches
          .map((match) => match.group(1)?.trim() ?? '')
          .where((message) => message.isNotEmpty)
          .toList();
    } catch (e) {
      print('Errore nel caricamento dei messaggi: $e');
      return [];
    }
  }

  static Future<List<Map<String, String>>> loadRawStories() async {
    try {
      final String content = await rootBundle.loadString('assets/stories.txt');
      final List<String> allContent = content.split('\n');
      Set<String> uniqueTitles = {}; // Per tracciare i titoli già visti
      List<Map<String, String>> stories = [];
      
      String currentTitle = '';
      List<String> currentContent = [];
      
      for (int i = 0; i < allContent.length; i++) {
        final line = allContent[i].trim();
        
        if (line.startsWith('"') && line.endsWith('"')) {
          // Salva la storia precedente se esiste
          if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
            final title = currentTitle.trim();
            if (!uniqueTitles.contains(title)) {
              uniqueTitles.add(title);
              stories.add({
                'title': title,
                'content': currentContent.join('\n').trim(),
              });
            }
          }
          // Inizia una nuova storia
          currentTitle = line.substring(1, line.length - 1);
          currentContent = [];
        }
        // Trova la fine della storia (riga che termina con ❤️)
        else if (line.endsWith('❤️')) {
          currentContent.add(line);
          final title = currentTitle.trim();
          if (!uniqueTitles.contains(title)) {
            uniqueTitles.add(title);
            stories.add({
              'title': title,
              'content': currentContent.join('\n').trim(),
            });
          }
          currentTitle = '';
          currentContent = [];
        }
        // Aggiunge le righe al contenuto corrente
        else if (line.isNotEmpty && currentTitle.isNotEmpty) {
          currentContent.add(line);
        }
      }
      
      print('Storie caricate: ${stories.length}'); // Debug info
      return stories;
    } catch (e) {
      print('Errore nel caricamento delle storie: $e');
      return [];
    }
  }
}
