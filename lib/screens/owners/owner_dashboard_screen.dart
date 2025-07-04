import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/select-role', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String turfName = "GreenField Turf";
    String turfLocation = "Chennai, Tamil Nadu";
    double rating = 4.5;
    bool isAvailable = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Dashboard"),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset("assets/turf_sample.jpg", width: 60, height: 60, fit: BoxFit.cover),
                ),
                title: Text(turfName),
                subtitle: Text(turfLocation),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(rating.toString())
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _DashboardStat(title: "Total Bookings", value: "124"),
                _DashboardStat(title: "Upcoming", value: "18"),
                _DashboardStat(title: "Completed", value: "106"),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: Colors.green, size: 40),
                title: const Text("Total Earnings"),
                subtitle: const Text("₹ 42,500"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/owner/earnings'),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_location_alt, color: Colors.blue),
                    title: const Text("Edit Turf Details"),
                    onTap: () => Navigator.pushNamed(context, '/owner/edit-turf'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.orange),
                    title: const Text("Manage Availability"),
                    onTap: () => Navigator.pushNamed(context, '/owner/slots'),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text("Turf Availability"),
                    value: isAvailable,
                    onChanged: (val) {},
                    secondary: const Icon(Icons.toggle_on, color: Colors.teal),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.message, color: Colors.purple),
                title: const Text("User Messages"),
                subtitle: const Text("3 New Messages"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/owner/messages'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/owner/add-turf'),
              icon: const Icon(Icons.add_business),
              label: const Text("Add New Turf"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
