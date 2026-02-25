import 'package:flutter/material.dart';
import 'package:flutter_auth_app/models/auth_model.dart';
import 'package:flutter_auth_app/models/user_model.dart';
import 'package:flutter_auth_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  SessionDTO? session;
  bool isLoading = false;

  bool get isAuthenticated => session != null;

  Future<void> login(LoginDTO log) async {
    isLoading = true;
    notifyListeners();

    try {
      session = await AuthService.login(log);
      print('✅ Login exitoso: ${session?.token}');
      print('✅ Usuario: ${session?.userId}'); // si tu SessionDTO tiene user
    } catch (e){
      print('❌ Error en login: $e'); // 👈 muy importante, captura el error
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User> register(UserCreate data) async {
    isLoading=true;
    notifyListeners();

    try{
      return await AuthService.register(data);

    }finally{
      isLoading=false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    session = null;
    notifyListeners();
  }
}