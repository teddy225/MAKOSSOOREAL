import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user.dart';

// AuthService.dart

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.adminmakossoapp.com/api/v1/auth',
    headers: {'Content-Type': 'application/json'},
  ));

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Inscription de l'utilisateur
  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/register', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Succès
      }
      return false; // Échec
    } catch (e) {
      print('Erreur lors de l\'inscription : $e');
      return false; // Échec
    }
  }

  // Connexion de l'utilisateur et récupération du token
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['access_token'];
      await _secureStorage.write(key: 'auth_token', value: token);

      return {
        'user': User.fromJson(response.data['user']),
        'token': token,
      };
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      await _dio.post('/logout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      await _secureStorage.delete(key: 'auth_token');
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le profil de l'utilisateur
  Future<User> getProfile() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final response = await _dio.get('/profil',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return User.fromJson(response.data['user']);
    } catch (e) {
      rethrow;
    }
  }
}
