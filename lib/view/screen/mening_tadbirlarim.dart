import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/model/tadbir.dart';
import 'package:imtixon_4_oy/services/tadbir_service.dart';
import 'package:imtixon_4_oy/view/screen/add_tadbir.dart';
import 'package:imtixon_4_oy/view/widgets/event_list.dart';
import 'package:provider/provider.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mening tadbirlarim'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tashkil qilganlarim'),
              Tab(text: 'Yaqinda'),
              Tab(text: 'Ishtirok etganlarim'),
              Tab(text: 'Bekor qilinganlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildEventList(eventService.organizedEvents),
            buildEventList(eventService.upcomingEvents),
            buildEventList(eventService.participatedEvents),
            buildEventList(eventService.canceledEvents),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildEventList(List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventListItem(event: events[index]);
      },
    );
  }
}
