import 'package:flutter/foundation.dart';
import '../models/daily_message.dart';
import '../models/weekly_story.dart';
import '../services/content_service.dart';
import '../models/app_error.dart';

class AppState with ChangeNotifier {
  final ContentService _contentService;
  bool _isLoading = true;
  DailyMessage? _currentMessage;
  WeeklyStory? _currentStory;
  List<DailyMessage> _favoriteMessages = [];
  List<WeeklyStory> _favoriteStories = [];
  AppError? _lastError;

  AppState(this._contentService) {
    _initialize();
  }

  bool get isLoading => _isLoading;
  DailyMessage? get currentMessage => _currentMessage;
  WeeklyStory? get currentStory => _currentStory;
  List<DailyMessage> get favoriteMessages => _favoriteMessages;
  List<WeeklyStory> get favoriteStories => _favoriteStories;
  AppError? get lastError => _lastError;

  Future<void> _initialize() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      await _contentService.initialize();
      await _loadContent();
      await _loadFavorites();
    } catch (e) {
      _lastError = e is AppError ? e : AppError(
        message: 'Si è verificato un errore',
        details: e.toString(),
        type: ErrorType.unknown,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryInitialization() async {
    await _initialize();
  }

  Future<void> _loadContent() async {
    _currentMessage = await _contentService.getDailyMessage();
    
    _currentStory = await _contentService.getWeeklyStory();
    
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    _favoriteMessages = await _contentService.getFavoriteMessages();
    _favoriteStories = await _contentService.getFavoriteStories();
    notifyListeners();
  }

  Future<void> toggleMessageFavorite(DailyMessage message, {bool remove = false}) async {
    await _contentService.toggleMessageFavorite(message, remove: remove);
    await _loadFavorites();
  }

  Future<void> toggleStoryFavorite(WeeklyStory story, {bool remove = false}) async {
    await _contentService.toggleStoryFavorite(story, remove: remove);
    await _loadFavorites();
  }

  Future<void> saveMessageComment(DailyMessage message, String? comment) async {
    await _contentService.saveMessageComment(message, comment);
    if (comment != null) {
      message.comment = comment;
      notifyListeners();
    }
  }

  Future<void> saveStoryComment(WeeklyStory story, String? comment) async {
    await _contentService.saveStoryComment(story, comment);
    await _loadContent(); // Ricarica il contenuto per aggiornare la UI
  }
}
