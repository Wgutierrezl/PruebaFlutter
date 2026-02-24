import 'package:flutter/foundation.dart';
import 'package:flutter_auth_app/models/role_model.dart';
import 'package:flutter_auth_app/services/role_service.dart';

class RoleProvider extends ChangeNotifier{
  List<Role> roles=[];
  Role? selectedRole;

  bool isLoading=false;
  String? error;


  Future<void> getAllRoles() async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      roles=await RoleService.getAllRoles();

    }catch(e){
      error=e.toString();
    } finally {
      isLoading=false;
      notifyListeners();
    }
  }

  Future<Role?> createRole(RoleCreate data) async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      return await RoleService.createRole(data);
    }catch(e){
      error=e.toString();
      return null;
    } finally {
      isLoading=false;
      notifyListeners();
    }
  }

  Future<void> getRoleById(int id) async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      selectedRole=await RoleService.getRoleById(id);
    }catch(e){
      error=e.toString();
    } finally {
      isLoading=false;
      notifyListeners();
    }
  }

  Future<void> deleteRoleId(int id) async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      await RoleService.deleteRolById(id);
      roles.removeWhere((u) => u.id==id);
    }catch(e){
      error=e.toString();
    } finally {
      isLoading=false;
      notifyListeners();
    }
  }

  Future<Role?> updateRoleId(int id, RoleUpdated data) async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      final updated=await RoleService.updateRoleById(id, data);
      selectedRole=updated;
      return updated;
    }catch(e){
      error=e.toString();
      return null;

    } finally {
      isLoading=false;
      notifyListeners();
    }
  } 
}