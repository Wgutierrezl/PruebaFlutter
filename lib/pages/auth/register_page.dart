import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';
import 'package:flutter_auth_app/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final roleCtrl = TextEditingController(); // corregido
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: roleCtrl,
              keyboardType: TextInputType.number, // roleId es int
              decoration: const InputDecoration(labelText: 'Role ID'),
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
                  username: nameCtrl.text,           // corregido: name -> username
                  roleId: int.tryParse(roleCtrl.text) ?? 1, // corregido: campo requerido
                  email: emailCtrl.text,
                  password: passCtrl.text,
                );

                await auth.register(dto);

                if (mounted) Navigator.pop(context);
              },
              child: auth.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}