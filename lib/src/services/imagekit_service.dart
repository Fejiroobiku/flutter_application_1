import 'dart:io';
import 'dart:typed_data';
import '../data/datasources/firebase_storage_datasource.dart';

class ImageKitService {
  final FirebaseStorageDatasource _storage;

  ImageKitService({FirebaseStorageDatasource? storage})
      : _storage = storage ?? FirebaseStorageDatasource();

  Future<String> uploadEventImage({
    required String uid,
    required String eventId,
    Uint8List? bytes,
    File? file,
    String contentType = 'image/jpeg',
  }) {
    return _storage.uploadEventImage(
      uid: uid,
      eventId: eventId,
      bytes: bytes,
      file: file,
      contentType: contentType,
    );
  }

  Future<void> deleteEventImage({
    required String uid,
    required String eventId,
  }) {
    return _storage.deleteEventImage(uid: uid, eventId: eventId);
  }
}
