import 'package:flutter/foundation.dart';
import 'package:flutter_auth_app/models/user_model.dart';
import 'package:flutter_auth_app/services/user_service.dart';

class UserProvider extends ChangeNotifier{
  List<User> users=[];
  User? profile;
  User? selectedUser;

  bool isLoading=false;
  String? error;

  Future<void> loadProfile() async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      profile=await UserService.getProfile();
    }catch(e){
      error=e.toString();
    } finally {
      isLoading=false;
      notifyListeners();
    }

  }

  Future<void> loadUsers() async {
    isLoading=true;
    error=null;
    notifyListeners();

    try{
      users=await UserService.getAllUsers();
    }catch(e){
      error=e.toString();
    } finally {
      isLoading=false;
      notifyListeners();
    }
  }

  Future<void> getUser(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      selectedUser = await UserService.getUserById(id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await UserService.deleteUserById(id);
      users.removeWhere((u) => u.id == id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> updateProfile(UserUpdate data) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updated = await UserService.updateUserProfile(data);
      profile = updated;
      return updated;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}