import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup Permissions")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PermissionTile(
            title: "Microphone",
            icon: Icons.mic,
            onGrant: () => Permission.microphone.request(),
          ),
          _PermissionTile(
            title: "Overlay",
            icon: Icons.layers,
            onGrant: () => Permission.systemAlertWindow.request(),
          ),
          _PermissionTile(
            title: "Accessibility Service",
            icon: Icons.accessibility,
            onGrant: () {
              // Open accessibility settings
            },
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onGrant;

  const _PermissionTile({
    required this.title,
    required this.icon,
    required this.onGrant,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: ElevatedButton(
        onPressed: onGrant,
        child: const Text("Grant"),
      ),
    );
  }
}