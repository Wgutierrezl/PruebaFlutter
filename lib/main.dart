import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';
import 'package:flutter_auth_app/providers/role_provider.dart';
import 'package:flutter_auth_app/providers/user_provider.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth App',
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}

