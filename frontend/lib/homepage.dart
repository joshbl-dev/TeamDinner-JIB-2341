import 'package:flutter/material.dart';
import 'package:frontend/pages/messages.dart';
import 'package:frontend/pages/polls.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/teams.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _selectedIndex = 0;
const List<Widget> _widgetOptions = <Widget>[
  MessagesPage(),
  PollsPage(),
  TeamPage(),
  MessagesPage(),
  ProfilePage(),
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        centerTitle: true,
        title: const Text('T E A M D I N N E R'),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20,
          ),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey,
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.message,
                text: 'Messages',
              ),
              GButton(
                icon: Icons.poll,
                text: 'Poll',
              ),
              GButton(
                icon: Icons.group,
                text: 'Team',
              ),
              GButton(
                icon: Icons.message,
                text: 'Messages',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
              //GButton(icon: Icons.people),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
