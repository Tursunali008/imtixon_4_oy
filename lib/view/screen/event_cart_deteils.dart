import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/model/tadbir.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Point? _selectedPoint;
  YandexMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      setState(() {
        _selectedPoint = widget.event.location;
      });
      _mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: widget.event.location, zoom: 14),
        ),
      );
    } catch (e) {
      debugPrint('Error initializing map: $e');
    }
  }

  void _onMapTap(Point point) {
    setState(() {
      _selectedPoint = point;
    });

    _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: point, zoom: 14)),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tabriklaymiz!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Siz Flutter Global Hakaton 2024 tadbiriga muvaffaqiyatli ro\'yxatdan o\'tdingiz.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
                child: const Text('Eslatma Belgilash'),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to the home screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text('Bosh Sahifa'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.event.placeName;

    return Scaffold(
      appBar: AppBar(
        actions: [
          const Icon(Icons.more_vert_outlined),
        ],
        title: Text(widget.event.name),
        backgroundColor: Colors.deepPurple[300], // Adjust as needed
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.event.bannerUrl),
              const SizedBox(height: 16.0),
              Text(
                widget.event.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8.0),
                  Text('${widget.event.date}, ${widget.event.time}'),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(width: 8.0),
                  Text(location),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Tadbir haqida',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(widget.event.description),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: YandexMap(
                    gestureRecognizers: Set()
                      ..add(Factory<EagerGestureRecognizer>(
                          () => EagerGestureRecognizer())),
                    onMapTap: _onMapTap,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_selectedPoint != null) {
                        controller.moveCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(target: _selectedPoint!, zoom: 14),
                        ));
                      }
                    },
                    mapObjects: _selectedPoint != null
                        ? [
                            PlacemarkMapObject(
                              mapId: const MapObjectId('placemark_1'),
                              point: _selectedPoint!,
                              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                image: BitmapDescriptor.fromAssetImage(
                                    'assets/images/place.png'),
                                scale: 0.05,
                              )),
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
                child: const Text('Ro\'yxatdan O\'tish'),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.event.cancel();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Bekor Qilish'),
            ),
          ],
        ),
      ),
    );
  }
}
