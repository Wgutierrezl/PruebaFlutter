import 'dart:convert';

import 'package:flutter_auth_app/core/api_client.dart';
import 'package:flutter_auth_app/models/role_model.dart';

class RoleService {
  
  static Future<List<Role>> getAllRoles() async{
    final response=await ApiClient.get('/roles/getAllRoles');
    if(response.statusCode==200){
      final List<dynamic> data=jsonDecode(response.body);
      return data.map((roleJson)=> Role.fromJson(roleJson)).toList();
    } else if(response.statusCode==404){
      throw Exception('Aun no hay roles creados');
    }else if(response.statusCode==401){
      throw Exception('No estas autenticado');
    }

    throw Exception('No hemos encontrado roles');
    
  }

  static Future<Role> createRole(RoleCreate role) async {
    final response=await ApiClient.post('/roles/createRole',body: role.toJson());
    if(response.statusCode==201){
      final data=jsonDecode(response.body);
      return Role.fromJson(data);
    }else{
      throw Exception('no hemos logrado crear el rol');
    }
  }

  static Future<Role> getRoleById(int id) async {
    final response=await ApiClient.get('/roles/getRoleById/$id');
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return Role.fromJson(data);
    }else if(response.statusCode==404){
      throw Exception('No existe el rol que deseas buscar');
    }

    throw Exception('no hemos logrado buscar el rol por id');
  }

  static Future<bool> deleteRolById(int id) async {
    final response=await ApiClient.delete('/roles/deleteRole/$id');
    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
  }

  static Future<Role> updateRoleById(int id, RoleUpdated role) async {
    final response=await ApiClient.put('/roles/updateRole/$id', body: role.toJson());
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      return Role.fromJson(data);
    }else if(response.statusCode==404){
      throw Exception('No existe el rol que deseas modificar');
    }

    throw Exception('no hemos logrado actualizar el rol por id');

  }
}