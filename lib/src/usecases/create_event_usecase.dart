import 'dart:io';
import 'dart:typed_data';
import '../../models/event_model.dart';
import '../../repositories/event_repository.dart';

class CreateEventUsecase {
  final EventRepository repository;
  CreateEventUsecase({required this.repository});

  Future<Event> execute({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String ownerId,
    Uint8List? imageBytes,
    File? imageFile,
    String? filename,
  }) {
    return repository.createEvent(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      ownerId: ownerId,
      imageBytes: imageBytes,
      imageFile: imageFile,
      filename: filename,
    );
  }
}
