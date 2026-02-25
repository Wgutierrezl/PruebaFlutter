import 'package:flutter/material.dart';
import 'package:flutter_auth_app/pages/auth/login_page.dart';
import 'package:flutter_auth_app/pages/auth/register_page.dart';
import 'package:flutter_auth_app/pages/home/home_page.dart';
import 'package:flutter_auth_app/pages/roles/roles_page.dart';
import 'package:flutter_auth_app/pages/users/users_page.dart';
import 'package:flutter_auth_app/pages/users/create_user_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const roles = '/roles';
  static const users = '/users';
  static const createUser = '/users/create';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (_) => const HomePage(),
    roles: (_) => const RolesPage(),
    users: (_) => const UsersPage(),
    createUser: (_) => const CreateUserPage(),
  };
}