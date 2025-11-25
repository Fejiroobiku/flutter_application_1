import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an event image and returns its download URL.
  /// Storage path: 'events/{uid}/{eventId}.jpg'
  /// On web provide `bytes`, on mobile provide `file`.
  Future<String> uploadEventImage({
    required String uid,
    required String eventId,
    Uint8List? bytes,
    File? file,
    String contentType = 'image/jpeg',
  }) async {
    final path = 'events/$uid/$eventId.jpg';
    final ref = _storage.ref().child(path);
    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'public,max-age=3600',
    );

    UploadTask uploadTask;
    if (kIsWeb) {
      if (bytes == null) throw ArgumentError('bytes required for web upload');
      uploadTask = ref.putData(bytes, metadata);
    } else {
      if (file == null) throw ArgumentError('file required for mobile upload');
      uploadTask = ref.putFile(file, metadata);
    }

    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  /// Deletes the event image at 'events/{uid}/{eventId}.jpg' (ignores not-found).
  Future<void> deleteEventImage({
    required String uid,
    required String eventId,
  }) async {
    final path = 'events/$uid/$eventId.jpg';
    try {
      await _storage.ref().child(path).delete();
    } catch (_) {
      // ignore errors (file may not exist)
    }
  }
}
