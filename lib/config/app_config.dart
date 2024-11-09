class AppConfig {
  static const bool isTestMode = true;
  
  static bool get forceMonday => isTestMode;
  static bool get showStoryInstead => isTestMode;
}
