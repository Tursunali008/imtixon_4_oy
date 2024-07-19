import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/model/tadbir.dart';
import 'package:imtixon_4_oy/view/screen/event_cart_deteils.dart';

class EventListItem extends StatefulWidget {
  final Event event;

  const EventListItem({Key? key, required this.event}) : super(key: key);

  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: widget.event),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: widget.event.bannerUrl.isNotEmpty
              ? Image.network(widget.event.bannerUrl)
              : Image.asset('assets/icons/no_image.jpg'),
          title: Text(widget.event.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.event.date}, ${widget.event.time}'),
              Text(widget.event.placeName),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorited = !_isFavorited;
              });
            },
          ),
        ),
      ),
    );
  }
}
