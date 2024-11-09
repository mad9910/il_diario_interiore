import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/app_state.dart';
import 'services/content_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final contentService = ContentService(await SharedPreferences.getInstance());
  await contentService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ContentService>(
          create: (_) => contentService,
        ),
        ChangeNotifierProvider(
          create: (context) => AppState(contentService),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaggi Quotidiani',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
