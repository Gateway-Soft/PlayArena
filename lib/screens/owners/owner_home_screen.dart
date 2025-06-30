import 'package:flutter/material.dart';

import 'owner_profile_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OwnerHomeBody(),
    const OwnerProfileScreen(),
    const OwnerSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class OwnerHomeBody extends StatelessWidget {
  const OwnerHomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ownerName = "Srigunaseelan"; // TODO: Get dynamically from Firestore

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome, $ownerName 👋",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text("Manage your turf and track bookings in one place"),

            const SizedBox(height: 24),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _OwnerActionCard(
                  icon: Icons.calendar_month,
                  title: 'Bookings',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to bookings screen
                  },
                ),
                _OwnerActionCard(
                  icon: Icons.attach_money,
                  title: 'Earnings',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to earnings screen
                  },
                ),
                _OwnerActionCard(
                  icon: Icons.sports_soccer,
                  title: 'Manage Turf',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to turf manage screen
                  },
                ),
                _OwnerActionCard(
                  icon: Icons.message,
                  title: 'Messages',
                  color: Colors.purple,
                  onTap: () {
                    // Navigate to messages screen
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _OwnerActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _OwnerActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
