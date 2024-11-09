import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_app/services/content_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ContentService contentService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    contentService = ContentService(mockPrefs);
  });

  group('ContentService Tests', () {
    test('getDailyMessage returns new message when date changes', () async {
      // Arrange
      when(mockPrefs.getString('lastMessageDate'))
          .thenReturn(DateTime(2023, 1, 1).toIso8601String());
      
      // Act
      final message = await contentService.getDailyMessage();
      
      // Assert
      expect(message, isNotNull);
      verify(mockPrefs.setString('lastMessageDate', any)).called(1);
    });

    test('getWeeklyStory returns same story within week', () async {
      // Arrange
      final weekStart = DateTime.now();
      when(mockPrefs.getString('lastStoryDate'))
          .thenReturn(weekStart.toIso8601String());
      when(mockPrefs.getString('currentStoryTitle'))
          .thenReturn('Test Story');
      
      // Act
      final story1 = await contentService.getWeeklyStory();
      final story2 = await contentService.getWeeklyStory();
      
      // Assert
      expect(story1.title, equals(story2.title));
    });
  });
}
