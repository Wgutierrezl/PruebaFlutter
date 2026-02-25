import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/models/user_model.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final nameCtrl = TextEditingController();
  final roleIdCtrol=TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.isLoading ? null : () async {
                final dto = UserCreate(
                  username: nameCtrl.text,
                  roleId: int.tryParse(roleIdCtrol.text) ?? 1,
                  email: emailCtrl.text,
                  password: passCtrl.text,
                );

                await auth.register(dto);

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}