import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  String ownerId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              title: "My Turfs",
              icon: Icons.sports_soccer,
              color: Colors.orange,
              valueStream: FirebaseFirestore.instance
                  .collection('turfs')
                  .where('ownerId', isEqualTo: ownerId)
                  .snapshots(),
            ),
            _DashboardCard(
              title: "Total Bookings",
              icon: Icons.calendar_month,
              color: Colors.blue,
              valueStream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('ownerId', isEqualTo: ownerId)
                  .snapshots(),
            ),
            _DashboardCard(
              title: "Total Earnings",
              icon: Icons.attach_money,
              color: Colors.green,
              valueStream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('ownerId', isEqualTo: ownerId)
                  .snapshots(),
              calculateEarnings: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Stream<QuerySnapshot> valueStream;
  final bool calculateEarnings;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.valueStream,
    this.calculateEarnings = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: valueStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            elevation: 3,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final count = snapshot.data!.docs.length;

        double totalEarnings = 0;
        if (calculateEarnings) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final price = double.tryParse(data['price'].toString()) ?? 0;
            totalEarnings += price;
          }
        }

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 12),
                Text(
                  calculateEarnings
                      ? "₹ ${totalEarnings.toStringAsFixed(2)}"
                      : "$count",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
