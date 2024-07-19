import 'package:flutter/foundation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Event {
  final String id;
  final String name;
  final String date;
  final String time;
  final String description;
  final String imageUrl;
  final String placeName;
  final Point location;
  bool _isCanceled;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
    required this.placeName,
    required this.location,
    bool isCanceled = false, // Add a default value
  }) : _isCanceled = isCanceled;

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      placeName: data['placeName'] ?? '',
      location: Point(
        latitude: data['location']['latitude'],
        longitude: data['location']['longitude'],
      ),
      isCanceled: data['isCanceled'] ?? false, // Handle isCanceled field
    );
  }

  bool get isOrganizedByUser => false;

  bool get isUpcoming {
    try {
      DateTime eventDateTime = DateTime.parse('$date $time');
      DateTime now = DateTime.now();
      return eventDateTime.isAfter(now);
    } catch (e) {
      debugPrint('Error parsing date/time: $e');
      return false;
    }
  }

  bool get isParticipated {
    try {
      DateTime eventDateTime = DateTime.parse('$date $time');
      DateTime now = DateTime.now();
      return eventDateTime.isBefore(now);
    } catch (e) {
      debugPrint('Error parsing date/time: $e');
      return false;
    }
  }

  bool get isCanceled => _isCanceled;

  void cancel() {
    _isCanceled = true;
  }

  String get bannerUrl => imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'description': description,
      'image_url': imageUrl,
      'placeName': placeName,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'isCanceled': _isCanceled,
    };
  }

  Event copyWith({
    Point? location,
    String? id,
    String? name,
    String? date,
    String? time,
    String? description,
    String? imageUrl,
    String? placeName,
    bool? isCanceled,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      placeName: placeName ?? this.placeName,
      location: location ?? this.location,
      isCanceled: isCanceled ?? this._isCanceled,
    );
  }
}
