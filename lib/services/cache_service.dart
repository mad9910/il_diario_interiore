import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  static final DefaultCacheManager _instance = DefaultCacheManager();
  
  static Future<void> clearCache() async {
    await _instance.emptyCache();
  }
  
  static Future<void> removeFile(String url) async {
    await _instance.removeFile(url);
  }
  
  static Stream<FileResponse> getFileStream(String url) {
    return _instance.getFileStream(
      url,
      withProgress: true,
    );
  }
}
