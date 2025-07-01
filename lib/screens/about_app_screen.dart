import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String appName = "PlayArena";
  String version = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About App")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo
            Image.asset(
              'assets/PlayArena splash screen logo.jpg',
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),

            // App name and version
            Text(
              appName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              "Version $version",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // App description
            const Text(
              "PlayArena is a modern turf booking platform that lets users find, book, and manage sports grounds easily. Owners can add turfs, manage slots, and view bookings in real time.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            const Divider(),

            // Developer Info
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Developed by"),
              subtitle: Text("Srigunaseelan S"),
            ),

            const ListTile(
              leading: Icon(Icons.location_city),
              title: Text("From"),
              subtitle: Text("Karaikudi, Tamil Nadu - 630108"),
            ),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: const Text("srigunaseelan2004@gmail.com"),
              onTap: () => _launchUrl("mailto:srigunaseelan2004@gmail.com"),
            ),

            ListTile(
              leading: const Icon(Icons.public),
              title: const Text("Website / Portfolio"),
              subtitle: const Text("Visit Developer"),
              onTap: () => _launchUrl("https://srigunas.github.io/portfolio/"), // update link
            ),

            const Divider(),

            const Text(
              "Powered by Gateway Software Solutions",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
