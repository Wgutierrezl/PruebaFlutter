import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: RefreshIndicator(
        onRefresh: provider.loadUsers,
        child: ListView.builder(
          itemCount: provider.users.length,
          itemBuilder: (_, i) {
            final u = provider.users[i];
            return ListTile(
              title: Text(u.username),
              subtitle: Text(u.email),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => provider.deleteUser(u.id),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.createUser),
      ),
    );
  }
}