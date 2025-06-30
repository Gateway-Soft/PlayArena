import 'package:flutter/material.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Dashboard"),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Add logout logic
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Turf Overview Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset("assets/turf_sample.jpg", width: 60, height: 60, fit: BoxFit.cover),
                ),
                title: const Text("GreenField Turf"),
                subtitle: const Text("Chennai, Tamil Nadu"),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star, color: Colors.amber),
                    Text("4.5")
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Booking Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _DashboardStat(title: "Total Bookings", value: "124"),
                _DashboardStat(title: "Upcoming", value: "18"),
                _DashboardStat(title: "Completed", value: "106"),
              ],
            ),

            const SizedBox(height: 20),

            // Earnings Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.green, size: 40),
                title: const Text("Total Earnings"),
                subtitle: const Text("₹ 42,500"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to Earnings details
                },
              ),
            ),

            const SizedBox(height: 20),

            // Manage Turf
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_location_alt, color: Colors.blue),
                    title: const Text("Edit Turf Details"),
                    onTap: () {
                      // Navigate to edit screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.orange),
                    title: const Text("Manage Availability"),
                    onTap: () {
                      // Navigate to manage availability
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Messages from users
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.message, color: Colors.purple),
                title: const Text("User Messages"),
                subtitle: const Text("3 New Messages"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to messages screen
                },
              ),
            ),

            const SizedBox(height: 30),

            // Logout
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add logout logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Helper Widget --------------------
class _DashboardStat extends StatelessWidget {
  final String title;
  final String value;

  const _DashboardStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
