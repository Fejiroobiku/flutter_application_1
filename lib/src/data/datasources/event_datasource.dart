import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here_bro/src/data/models/event.dart';

class EventDataSource {
  final FirebaseFirestore firestore;

  EventDataSource({required this.firestore});

  Future<List<EventModel>> getEvents() async {
    final snapshot = await firestore.collection('events').get();
    return snapshot.docs
        .map((doc) => EventModel.fromJson(doc.data()))
        .toList();
  }

  Future<EventModel> createEvent(EventModel event) async {
    final docRef = firestore.collection('events').doc();
    await docRef.set(event.toJson());
    return event.copyWith(id: docRef.id);
  }

  Future<EventModel> updateEvent(EventModel event) async {
    await firestore.collection('events').doc(event.id).update(event.toJson());
    return event;
  }

  Future<void> deleteEvent(String eventId) async {
    await firestore.collection('events').doc(eventId).delete();
  }

  Future<EventModel> getEventById(String eventId) async {
    final snapshot =
        await firestore.collection('events').doc(eventId).get();
    return EventModel.fromJson(snapshot.data()!);
  }
}