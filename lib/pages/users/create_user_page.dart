import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';
import 'package:flutter_auth_app/providers/role_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/models/user_model.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  int? selectedRoleId; // ← guarda el id del rol seleccionado

  @override
  void initState() {
    super.initState();
    // Carga los roles al abrir la pantalla
    Future.microtask(() =>
        context.read<RoleProvider>().getAllRoles()
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final roleProvider = context.watch<RoleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear usuario')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),

            // ── Selector de roles ──
            roleProvider.isLoading
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    value: selectedRoleId,
                    decoration: const InputDecoration(labelText: 'Rol'),
                    hint: const Text('Seleccionar rol'),
                    items: roleProvider.roles.map((role) {
                      return DropdownMenuItem<int>(
                        value: role.id,        // ← guarda el id
                        child: Text(role.name), // ← muestra el name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedRoleId = value);
                    },
                  ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.isLoading || selectedRoleId == null
                  ? null
                  : () async {
                      final dto = UserCreate(
                        username: nameCtrl.text,
                        roleId: selectedRoleId!, // ← usa el id seleccionado
                        email: emailCtrl.text,
                        password: passCtrl.text,
                      );

                      await auth.register(dto);

                      if (mounted) Navigator.pop(context);
                    },
              child: auth.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}