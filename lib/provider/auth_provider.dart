import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/authentification_service.dart';
import '../model/user.dart';

// AuthService provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// AuthNotifier provider pour gérer l'état de l'authentification
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  // Fonction d'enregistrement
  Future<bool> register(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final success = await _ref.read(authServiceProvider).register(data);
      if (success) {
        state = const AsyncValue.data(null);
        return true;
      } else {
        throw Exception("L'inscription a échoué.");
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  // Fonction de connexion
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final response =
          await _ref.read(authServiceProvider).login(email, password);
      final user = response['user'];
      final token = response['token'];

      await _secureStorage.write(key: 'auth_token', value: token);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // Fonction de déconnexion
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Utilisation de `FutureProvider` pour récupérer le profil utilisateur
final userProfileProvider = FutureProvider<User>((ref) async {
  final userService = ref.watch(authServiceProvider);
  return await userService.getProfile();
});
