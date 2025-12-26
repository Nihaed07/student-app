import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/home.dart';
import 'package:flutter_application_1/ui/report.dart';
import 'package:flutter_application_1/ui/settings.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectIndex = 0;

  List<Widget> pages = const [Home(), Report(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF0F1323),

        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
        currentIndex: selectIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined, color: Colors.white),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}