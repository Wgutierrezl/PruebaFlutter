import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    // Se ejecuta una vez al abrir la pantalla
    Future.microtask(() =>
        context.read<UserProvider>().loadUsers()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator()) // ← muestra loading
          : provider.error != null
              ? Center(child: Text('Error: ${provider.error}')) // ← muestra error
              : RefreshIndicator(
                  onRefresh: provider.loadUsers,
                  child: provider.users.isEmpty
                      ? const Center(child: Text('No hay usuarios'))
                      : ListView.builder(
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
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createUser),
      ),
    );
  }
}