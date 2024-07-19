import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:imtixon_4_oy/controller/auth_controller.dart';
import 'package:imtixon_4_oy/view/screen/mening_tadbirlarim.dart';
import 'package:imtixon_4_oy/view/screen/profile_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    setState(() {
      _isDarkMode = savedThemeMode == AdaptiveThemeMode.dark;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    if (_isDarkMode) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? tr('user_drawer.anonymous')),
            accountEmail: Text(user?.email ?? tr('user_drawer.no_email')),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage("assets/images/default_image.png")
                        as ImageProvider,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(tr('user_drawer.event')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(tr('user_drawer.profile')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(tr('user_drawer.change_language')),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(tr('user_drawer.language_title')),
                    content: DropdownButton<Locale>(
                      value: context.locale,
                      items: const [
                        DropdownMenuItem(
                          value: Locale("uz"),
                          child: Text("Uz"),
                        ),
                        DropdownMenuItem(
                          value: Locale("en"),
                          child: Text("En"),
                        ),
                      ],
                      onChanged: (Locale? value) {
                        if (value != null) {
                          context.setLocale(value);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.brightness_4),
            title: Text(tr('user_drawer.dark_mode')),
            value: _isDarkMode,
            onChanged: (bool value) {
              _toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(tr('user_drawer.logout')),
            onTap: () async {
              await authController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
