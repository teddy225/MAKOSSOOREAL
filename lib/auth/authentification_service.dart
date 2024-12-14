import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user.dart';

// AuthService.dart
class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.adminmakossoapp.com/api/v1/auth',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: Duration(seconds: 5), // 5 secondes
      receiveTimeout: Duration(seconds: 5), // 5 secondes
    ),
  );

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Inscription de l'utilisateur
  Future<bool> register(Map<String, dynamic> data) async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      final response = await _dio.post('/register', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Succès
      }
      print(
          'Erreur lors de l\'inscription : ${response.statusCode} - ${response.data}');
      return false;
    } catch (e) {
      if (e is DioException) {
        print(
            'Erreur réseau lors de l\'inscription : ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Erreur inconnue lors de l\'inscription : $e');
      }
      return false;
    }
  }

  // Connexion de l'utilisateur et récupération du token
  login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final token = response.data['access_token'];
        await _secureStorage.write(key: 'auth_token', value: token);
        print(User.fromJson(response.data['user']));
        print(token);
        return {
          'user': User.fromJson(response.data['user']),
          'token': token,
        };
      } else {
        throw Exception('Réponse inattendue : ${response.data}');
      }
    } catch (e) {
      if (e is DioException) {
        print(
            'Erreur réseau lors de la connexion : ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Erreur inconnue lors de la connexion : $e');
      }
      rethrow;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token != null) {
        await _dio.post(
          '/logout',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print('Déconnexion réussie');
      }
      await _secureStorage.delete(key: 'auth_token');
    } catch (e) {
      if (e is DioException) {
        print(
            'Erreur réseau lors de la déconnexion : ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Erreur inconnue lors de la déconnexion : $e');
      }
      rethrow;
    }
  }

  // Récupérer le profil de l'utilisateur
  Future<User> getProfile() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Token non disponible, veuillez vous reconnecter.');
      }

      final response = await _dio.get(
        '/profil',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['user']);
      } else {
        throw Exception(
            'Erreur lors de la récupération du profil : ${response.data}');
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print('Token expiré ou invalide. Redirection vers la connexion.');
        await logout();
      } else if (e is DioException) {
        print(
            'Erreur réseau lors de la récupération du profil : ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Erreur inconnue lors de la récupération du profil : $e');
      }
      rethrow;
    }
  }
}
