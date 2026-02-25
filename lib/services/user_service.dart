import 'dart:convert';

import 'package:flutter_auth_app/core/api_client.dart';
import 'package:flutter_auth_app/models/user_model.dart';

class UserService {

  static Future<User> getProfile() async {
    final response=await ApiClient.get('/users/profile');

    if(response.statusCode==200){
      final Map<String,dynamic> data=jsonDecode(response.body);
      return User.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception('Sesión expirada');
    }

    throw Exception('error al obtener el perfil');
  
  }

  static Future<List<User>> getAllUsers() async {
    final response=await ApiClient.get('/users/getAllUsers');
    print('users ${response}');

    if(response.statusCode==200){
      final List<dynamic> data= jsonDecode(response.body);
      return data.map((userJson) => User.fromJson(userJson)).toList();
    }else{
      throw Exception('Error al obtener usuarios');
    }
  }

  static Future<User> getUserById(int id) async {
    final response=await ApiClient.get('/users/getUserById/$id');

    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return User.fromJson(data);
    }else if (response.statusCode==404){
      throw Exception('Usuario no encontrado');
    }

    throw Exception('Error al obtener al usuario');

  }

  static Future<bool> deleteUserById(int id) async {
    final response=await ApiClient.delete('/users/deleteUser/$id');

    if(response.statusCode==200){
      return true;
    } else if(response.statusCode==404){
      throw Exception('No existe el usuario que deseas eliminar'); 
    }else if(response.statusCode==401){
      throw Exception('No estas autenticado');
    }

    throw Exception('No hemos logrado eliminar a el usuario');
  }

  static Future<User> updateUserProfile(UserUpdate userData) async {
    final response=await ApiClient.put('/users/updateProfile', body: userData.toJson());
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return User.fromJson(data);
    }else{
      throw Exception('no hemos logrado actualizar tu perfil');
    }
  }

}