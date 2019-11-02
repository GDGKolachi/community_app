import 'package:flutter/material.dart';
import 'package:flutter_pk/profile/profile_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

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
        _buildAboutItem(),
        _buildNavItem(
          context,
          Icons.person,
          'My profile',
          onTap: () => Navigator.push(context, FullScreenProfileDialog.route),
        ),
        _buildNavItem(
          context,
          Icons.exit_to_app,
          'Log out',
          onTap: () => signOut(context),
        ),
      ],
    );
  }

  AboutListTile _buildAboutItem() {
    return AboutListTile(
        applicationIcon: Image.asset(
          'assets/ic_gdg_app.png',
          height: 40,
        ),
        applicationName: 'GDG Kolachi',
        icon: Icon(Icons.info),
        aboutBoxChildren: <Widget>[
          Text('Google Developers Group Kolachi for Karachi'),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Image.asset('assets/facebook.png'),
                onPressed: () => launch('https://www.facebook.com/GDGKolachi'),
              ),
              IconButton(
                icon: Image.asset('assets/twitter.png'),
                onPressed: () => launch('https://www.twitter.com/GDGKolachi'),
              ),
              IconButton(
                icon: Image.asset('assets/instagram.png'),
                onPressed: () => launch('https://www.instagram.com/GDGKolachi'),
              ),
            ],
          ),
        ],
        applicationVersion: '1.0',
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
