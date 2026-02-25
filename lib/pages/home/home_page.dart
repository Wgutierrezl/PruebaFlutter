import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Usuarios'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.users),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Roles'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.roles),
          ),
        ],
      ),
    );
  }
}