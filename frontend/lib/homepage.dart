import 'package:flutter/material.dart';
import 'package:frontend/pages/createteam.dart';
import 'package:frontend/pages/group.dart';
import 'package:frontend/pages/messages.dart';
import 'package:frontend/pages/payment.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/search.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
int _selectedIndex = 0;
const List<Widget> _widgetOptions = <Widget>[
  SearchPage(),
  PaymentPage(),
  GroupPage(),
  MessagesPage(),
  ProfilePage(),
];
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) {
                    return const CreateTeamPage();
                  },
              ),
          );
        },
        child: const Icon(Icons.add),
      ),
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
                  icon: Icons.search,
                  text: 'Search',
              ),
              GButton(
                  icon: Icons.payment,
                  text: 'Payment',
              ),
              GButton(
                  icon: Icons.group,
                  text: 'Group',
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
