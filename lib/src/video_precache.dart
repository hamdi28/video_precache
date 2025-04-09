import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:video_precache/src/video_cache_manager.dart';

/// Initializes the video precache package with an optional FirebaseStorage instance.
/// If not provided, uses FirebaseStorage.instance.
void initializeVideoPrecache({FirebaseStorage? storage}) {
  if (storage != null && !GetIt.I.isRegistered<FirebaseStorage>()) {
    GetIt.I.registerSingleton<FirebaseStorage>(storage);
  }
}

/// Global instance of VideoCacheManager for easy access.
final videoCacheManager = VideoCacheManager();
