import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../ providers/auth_provider.dart';
import '../../ providers/locale_provider.dart';
import '../../theme/theme_provider.dart';
import '../../l10n/app_localizations.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  String _appVersion = '';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              loc.settings,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: Text(loc.enableNotifications),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.changeLanguage),
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeProvider.setLocale(newLocale);
                }
              },
              items: const [
                DropdownMenuItem(child: Text("English"), value: Locale('en')),
                DropdownMenuItem(child: Text("தமிழ்"), value: Locale('ta')),
                DropdownMenuItem(child: Text("हिन्दी"), value: Locale('hi')),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(loc.appVersion),
            subtitle: Text(_appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(loc.logout),
            onTap: () {
              Provider.of<AppAuthProvider>(context, listen: false).signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
      ),
    );
  }
}
