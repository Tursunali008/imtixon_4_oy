import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:imtixon_4_oy/services/tadbir_service.dart';
import 'package:imtixon_4_oy/view/screen/notification%20screen.dart';
import 'package:imtixon_4_oy/view/widgets/event_list.dart';
import 'package:imtixon_4_oy/view/widgets/my_drover_widget.dart';
import 'package:imtixon_4_oy/view/widgets/event_card.dart';
import 'package:imtixon_4_oy/model/tadbir.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchType = 'name';
  TextEditingController _searchController = TextEditingController();
  List<Event> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<EventService>().fetchEvents().then((_) {
        setState(() {
          filteredEvents = context.read<EventService>().events;
        });
      });
    });
  }

  void _showFilterMenu() {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'name',
          child: Text('Search by Name'),
        ),
        const PopupMenuItem<String>(
          value: 'location',
          child: Text('Search by Location'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          _searchType = value;
        });
      }
    });
  }

  void _searchEvents(String query) {
    List<Event> results = [];
    final events = context.read<EventService>().events;
    if (query.isEmpty) {
      results = events;
    } else {
      if (_searchType == 'name') {
        results = events
            .where((event) =>
                (event.name).toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (_searchType == 'location') {
        results = events
            .where((event) =>
                (event.placeName).toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }
    setState(() {
      filteredEvents = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('home_screen.title'.tr()),
        backgroundColor: const Color.fromRGBO(188, 167, 225, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchEvents,
                  decoration: InputDecoration(
                    constraints:
                        const BoxConstraints(maxWidth: 560, minHeight: 50),
                    hintText: 'Search ...',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _showFilterMenu,
                      icon: Icon(Icons.tune),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'home_screen.upcoming_week'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: eventService.events.map((event) {
                    return EventCard(event: event);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'home_screen.all_events'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: filteredEvents.map((event) {
                  return EventListItem(event: event);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
