import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

/// A manager for preloading and caching video URLs from Firebase Storage.
class VideoCacheManager {
  static final VideoCacheManager _instance = VideoCacheManager._internal();
  factory VideoCacheManager() => _instance;
  VideoCacheManager._internal();

  // Cache for preloaded video URLs
  final Map<String, String> _videoUrlCache = {};

  // Optional: Use GetIt for FirebaseStorage instance injection
  FirebaseStorage get _storage => GetIt.I.isRegistered<FirebaseStorage>()
      ? GetIt.I<FirebaseStorage>()
      : FirebaseStorage.instance;

  /// Preloads video URLs for a list of storage paths.
  /// [paths] is a list of Firebase Storage paths (e.g., 'videos/video1.mp4').
  /// [maxPreloads] limits the number of videos to preload.
  Future<void> preloadVideos(List<String> paths, {int maxPreloads = 3}) async {
    final limitedPaths = paths.take(maxPreloads).toList();
    await Future.wait(
      limitedPaths.map((path) => _preloadSingleVideo(path)),
    );
  }

  /// Preloads a single video URL for the given [path].
  Future<void> preloadVideo(String path) async {
    await _preloadSingleVideo(path);
  }

  /// Retrieves a cached video URL for the given [path].
  /// Returns null if the URL is not cached.
  String? getCachedUrl(String path) => _videoUrlCache[path];

  /// Clears the video URL cache.
  void clearCache() {
    _videoUrlCache.clear();
    debugPrint('Video URL cache cleared');
  }

  /// Internal method to preload a single video URL.
  Future<void> _preloadSingleVideo(String path) async {
    if (_videoUrlCache.containsKey(path)) return;

    try {
      final ref = _storage.ref(path);
      final url = await ref.getDownloadURL();
      _videoUrlCache[path] = url;
      debugPrint('Preloaded video URL for path $path: $url');
    } catch (e, stackTrace) {
      debugPrint('Failed to preload video URL for path $path: $e');
      // Optionally, integrate with a crash reporting service here
      // e.g., FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }
  }
}
