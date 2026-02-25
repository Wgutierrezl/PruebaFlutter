import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/providers/role_provider.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<RoleProvider>().getAllRoles()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Roles')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}'))
              : RefreshIndicator(
                  onRefresh: provider.getAllRoles,
                  child: provider.roles.isEmpty
                      ? const Center(child: Text('No hay roles'))
                      : ListView.builder(
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