import 'package:flutter/material.dart';
import 'package:flutter_pk/profile/profile_dialog.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(),
          ),
        ],
      ),
      drawer: Drawer(
        child: NavigationDrawerItems(),
      ),
    );
  }
}

class NavigationDrawerItems extends StatelessWidget {
  const NavigationDrawerItems({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Image.asset('assets/gdg_kolachi.png'),
        ),
        _buildNavItem(
          context,
          Icons.home,
          'Home',
        ),
        _buildNavItem(
          context,
          Icons.event,
          'Events',
        ),
        _buildNavItem(
          context,
          Icons.info,
          'About',
        ),
        _buildNavItem(
          context,
          Icons.notifications,
          'Notifications',
        ),
        _buildNavItem(
          context,
          Icons.person,
          'My profile',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenProfileDialog(),
              fullscreenDialog: true,
            ),
          ),
        ),
        _buildNavItem(
          context,
          Icons.exit_to_app,
          'Log out',
        ),
      ],
    );
  }

  ListTile _buildNavItem(BuildContext context, IconData icon, String title,
      {VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) onTap();
      },
    );
  }
}
