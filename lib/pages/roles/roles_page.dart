import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/providers/role_provider.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Roles')),
      body: RefreshIndicator(
        onRefresh: provider.getAllRoles,
        child: ListView.builder(
          itemCount: provider.roles.length,
          itemBuilder: (_, i) {
            final role = provider.roles[i];
            return ListTile(
              title: Text(role.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => provider.deleteRoleId(role.id),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: provider.getAllRoles,
      ),
    );
  }
}