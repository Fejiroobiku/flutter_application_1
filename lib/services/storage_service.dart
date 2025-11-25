import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload bytes (web) or file (mobile) to path "events/{eventId}/{filename}"
  /// Returns download URL.
  Future<String> uploadEventImage({
    required String eventId,
    required String filename,
    Uint8List? bytes,
    File? file,
    String? contentType,
  }) async {
    final path = 'events/$eventId/$filename';
    final ref = _storage.ref().child(path);

    try {
      if (kIsWeb) {
        if (bytes == null) throw ArgumentError('bytes required on web');
        final metadata = SettableMetadata(contentType: contentType ?? 'image/jpeg');
        final uploadTask = ref.putData(bytes, metadata);
        final snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } else {
        if (file == null) throw ArgumentError('file required on mobile');
        final metadata = SettableMetadata(contentType: contentType ?? 'image/jpeg');
        final uploadTask = ref.putFile(file, metadata);
        final snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      rethrow;
    }
  }
}
