import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_message.dart';
import '../models/weekly_story.dart';
import 'file_service.dart';
import '../models/app_error.dart';
import 'dart:convert';

class ContentService {
  final SharedPreferences _prefs;
  List<String> _messages = [];
  List<Map<String, String>> _stories = [];
  
  ContentService(this._prefs);

  Future<void> initialize() async {
    try {
      _messages = await FileService.loadRawMessages();
      _stories = await FileService.loadRawStories();
    } catch (e) {
      throw AppError.content(
        details: 'Impossibile caricare i contenuti iniziali: ${e.toString()}'
      );
    }
  }

  Future<DailyMessage?> getDailyMessage() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final savedDate = _prefs.getString('lastMessageDate');
      final lastDate = savedDate != null ? DateTime.parse(savedDate) : null;
      
      if (lastDate == null || lastDate.isBefore(today)) {
        final random = Random(today.millisecondsSinceEpoch);
        final randomMessage = _messages[random.nextInt(_messages.length)];
        
        final message = DailyMessage(
          text: randomMessage,
          date: today,
        );
        
        await _prefs.setString('currentMessage', message.text);
        await _prefs.setString('lastMessageDate', today.toIso8601String());
        
        return message;
      }
      
      final savedMessage = _prefs.getString('currentMessage');
      if (savedMessage != null) {
        return DailyMessage(
          text: savedMessage,
          date: today,
        );
      }
      
      return null;
    } catch (e) {
      throw AppError.storage(
        details: 'Errore nel recupero del messaggio giornaliero: ${e.toString()}'
      );
    }
  }

  Future<WeeklyStory?> getWeeklyStory() async {
    try {
      final now = DateTime.now();
      final isMonday = now.weekday == DateTime.monday;
      final currentWeekMonday = _getLastMonday(now);
      
      final savedDate = _prefs.getString('lastStoryDate');
      final lastDate = savedDate != null ? DateTime.parse(savedDate) : null;
      
      if (lastDate == null || lastDate.isBefore(currentWeekMonday)) {
        final random = Random(currentWeekMonday.millisecondsSinceEpoch);
        final randomStory = _stories[random.nextInt(_stories.length)];
        
        final story = WeeklyStory(
          title: randomStory['title']!,
          content: randomStory['content']!,
          date: currentWeekMonday,
        );
        
        await _prefs.setString('currentStory', jsonEncode(story.toJson()));
        await _prefs.setString('lastStoryDate', currentWeekMonday.toIso8601String());
        
        return story;
      }
      
      final savedStory = _prefs.getString('currentStory');
      if (savedStory != null) {
        return WeeklyStory.fromJson(jsonDecode(savedStory));
      }
      
      return null;
    } catch (e) {
      throw AppError.storage(
        details: 'Errore nel recupero della storia settimanale: ${e.toString()}'
      );
    }
  }

  DateTime _getLastMonday(DateTime date) {
    final diff = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - diff);
  }

  DateTime getNextMonday(DateTime date) {
    final lastMonday = _getLastMonday(date);
    return lastMonday.add(Duration(days: 7));
  }

  Future<List<DailyMessage>> getFavoriteMessages() async {
    final favorites = _prefs.getStringList('favoriteMessages') ?? [];
    return favorites.map((json) => DailyMessage.fromJson(jsonDecode(json))).toList();
  }

  Future<List<WeeklyStory>> getFavoriteStories() async {
    final favorites = _prefs.getStringList('favoriteStories') ?? [];
    return favorites.map((json) => WeeklyStory.fromJson(jsonDecode(json))).toList();
  }

  Future<void> toggleMessageFavorite(DailyMessage message, {bool remove = false}) async {
    try {
      final favorites = await getFavoriteMessages();
      final existingIndex = favorites.indexWhere((m) => m.text == message.text);
      
      if (remove) {
        if (existingIndex != -1) {
          favorites.removeAt(existingIndex);
          message.isFavorite = false;
        }
      } else {
        if (existingIndex != -1) {
          // Aggiorna il messaggio esistente
          favorites[existingIndex] = message;
        } else {
          // Aggiungi nuovo messaggio
          message.isFavorite = true;
          favorites.add(message);
        }
      }

      await _prefs.setStringList(
        'favoriteMessages',
        favorites.map((m) => jsonEncode(m.toJson())).toList(),
      );
    } catch (e) {
      throw AppError.storage(
        details: 'Errore nel salvataggio del messaggio: ${e.toString()}'
      );
    }
  }

  Future<void> toggleStoryFavorite(WeeklyStory story, {bool remove = false}) async {
    try {
      final favorites = await getFavoriteStories();
      final existingIndex = favorites.indexWhere((s) => s.title == story.title);
      
      if (remove) {
        if (existingIndex != -1) {
          favorites.removeAt(existingIndex);
          story.isFavorite = false;
        }
      } else {
        if (existingIndex != -1) {
          favorites[existingIndex] = story;
        } else {
          story.isFavorite = true;
          favorites.add(story);
        }
      }

      await _prefs.setStringList(
        'favoriteStories',
        favorites.map((s) => jsonEncode(s.toJson())).toList(),
      );
    } catch (e) {
      throw AppError.storage(
        details: 'Errore nel salvataggio della storia: ${e.toString()}'
      );
    }
  }

  Future<void> saveMessageComment(DailyMessage message, String? comment) async {
    try {
      if (comment?.isNotEmpty ?? false) {
        await _prefs.setString('message_comment_${message.date.toIso8601String()}', comment!);
      }
    } catch (e) {
      throw AppError.storage(
        details: 'Errore nel salvataggio del commento: ${e.toString()}'
      );
    }
  }

  Future<String?> getMessageComment(DateTime date) async {
    return _prefs.getString('message_comment_${date.toIso8601String()}');
  }

  Future<void> saveStoryComment(WeeklyStory story, String? comment) async {
    try {
      if (comment?.isNotEmpty ?? false) {
        await _prefs.setString('story_comment_${story.date.toIso8601String()}', comment!);
      }
    } catch (e) {
      throw AppError.storage(
        details: 'Errore nel salvataggio del commento della storia: ${e.toString()}'
      );
    }
  }

  Future<String?> getStoryComment(DateTime date) async {
    return _prefs.getString('story_comment_${date.toIso8601String()}');
  }
}
