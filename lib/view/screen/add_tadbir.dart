import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'home_screen.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _selectedImage;
  Point? _selectedPoint;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = 'events/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addEvent() async {
    setState(() {
      _isLoading = true;
    });

    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedImage == null ||
        _selectedPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill all fields, select an image, and pick a location')),
      );

      setState(() {
        _isLoading = false;
      });

      return;
    }

    final imageUrl = await _uploadImage(_selectedImage!);

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );

      setState(() {
        _isLoading = false;
      });

      return;
    }

    final event = {
      'name': _nameController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'description': _descriptionController.text,
      'image_url': imageUrl,
      'placeName': _locationController.text,
      'location': {
        'latitude': _selectedPoint!.latitude,
        'longitude': _selectedPoint!.longitude,
      },
    };

    await FirebaseFirestore.instance.collection('events').add(event);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added successfully')),
    );

    _nameController.clear();
    _dateController.clear();
    _timeController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImage = null;
      _selectedPoint = null;
      _isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _onMapTap(Point point) async {
    setState(
      () {
        _selectedPoint = point;
      },
    );

    try {
      const searchOptions =
          SearchOptions(searchType: SearchType.geo, resultPageSize: 1);
      final result = await YandexSearch.searchByPoint(
        point: point,
        searchOptions: searchOptions,
      );
      final locationString = await result.$2;

      setState(() {
        _locationController.text = locationString.items![0].name;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context);
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectTime(context);
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickImage(ImageSource.camera),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt),
                              Text('Camera'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_library),
                              Text('Gallery'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              if (_selectedImage != null)
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      _selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 12.0),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: YandexMap(
                  gestureRecognizers: Set()
                    ..add(Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())),
                  onMapTap: _onMapTap,
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
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _addEvent,
                child: _isLoading
                    ? const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
