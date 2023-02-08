import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: GNav(
        tabs: [
          GButton(icon: Icons.search),
          GButton(icon: Icons.payment),
          GButton(icon: Icons.group),
          GButton(icon: Icons.message),
          GButton(icon: Icons.people),
        ],
      ),
    );
  }
}
