import 'dart:convert';
import 'package:flutter_auth_app/models/auth_model.dart';
import 'package:flutter_auth_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';
import '../core/token_storage.dart';

class AuthService{

  static Future<SessionDTO> login(LoginDTO login) async {
    final response = await ApiClient.post(
      '/users/login',
      body: login.toJson(),
    );

    print('📥 Status: ${response.statusCode}'); // código de respuesta
    print('📥 Body: ${response.body}');          // lo que te devuelve la API

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final session = SessionDTO.fromJson(data);

      await TokenStorage.save(session.token);

      return session;
    } else {
      throw Exception('Credenciales inválidas');
    }
  }

  static Future<User> register(UserCreate user) async {
    final response=await ApiClient.post('/users/register', body: user.toJson());

    if(response.statusCode==201){

      final data=jsonDecode(response.body);
      return User.fromJson(data);

    }else{
      throw Exception('Error al registrar usuario');
    }

  }
}