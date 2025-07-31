import 'package:flutter/material.dart';
import 'package:hivelocaldb/DB/functions/db_functions.dart';
import 'package:hivelocaldb/screens/all_orders_scren.dart';
import 'package:hivelocaldb/screens/create_order_screen.dart';
import 'package:hivelocaldb/screens/profile_screen.dart';

class MainScreenNavControl extends StatefulWidget {
  const MainScreenNavControl({super.key});

  @override
  State<MainScreenNavControl> createState() => _MainScreenNavControlState();
}

class _MainScreenNavControlState extends State<MainScreenNavControl> {
  int currentIndex = 0;

  final List<Widget> screens = [
    AllOrdersScreen(),
    CreateOrderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    getAllOrder();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 3,
                  offset: Offset(2, 3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              backgroundColor: Colors.white,
              selectedItemColor: Colors.green[900],
              unselectedItemColor: Colors.black54,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: [
                _customBarItem(Icons.list_alt, "Orders", 0),
                _customBarItem(Icons.add, "Create Order", 1),
                _customBarItem(Icons.person, "Profile", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _customBarItem(
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.green[900], // <-- selected color
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black54,
          size: 24,
        ),
      ),
      label: label,
    );
  }
}
