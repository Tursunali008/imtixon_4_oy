import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Xabarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            NotificationItem(
              name: 'Botir Murodov',
              message: 'Universitetlar boʻyicha tadbirda qatnashish uchun berildi, qatnashish olinish...',
              time: '22:00 19-iyun, 2024',
              avatarUrl: 'assets/images/avatar1.png',
            ),
            NotificationItem(
              name: 'Aziza Nodirova',
              message: 'Universitetlar boʻyicha tadbirda qatnashish uchun berildi, qatnashish olinish...',
              time: '22:00 19-iyun, 2024',
              avatarUrl: 'assets/images/avatar2.png',
            ),
            NotificationItem(
              name: 'Alisher Zokirov',
              message: 'Flutter Global Hakaton 2024 tadbiriga qatnashish uchun. Tafsilotlarni kuzatishingiz...',
              time: '22:00 19-iyun, 2024',
              avatarUrl: 'assets/images/avatar3.png',
            ),
            // Add more NotificationItem widgets here
          ],
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  const NotificationItem({super.key, 
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatarUrl),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      trailing: const Icon(Icons.more_vert),
      isThreeLine: true,
    );
  }
}
