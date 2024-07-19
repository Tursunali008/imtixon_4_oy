import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/model/tadbir.dart';

class EventService with ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;
  List<Event> get organizedEvents => _events.where((event) => event.isOrganizedByUser).toList();
  List<Event> get upcomingEvents => _events.where((event) => event.isUpcoming).toList();
  List<Event> get participatedEvents => _events.where((event) => event.isParticipated).toList();
  List<Event> get canceledEvents => _events.where((event) => event.isCanceled).toList();

  EventService() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('events').get();
      _events.clear();
      for (var doc in snapshot.docs) {
        _events.add(Event.fromMap(doc.data(), doc.id));
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('events').add(event.toMap());
      _events.add(event.copyWith(id: docRef.id));
      notifyListeners();
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(event.id).update(event.toMap());
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
      _events.removeWhere((event) => event.id == eventId);
      notifyListeners();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
