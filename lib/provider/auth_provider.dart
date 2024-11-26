import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/authentification_service.dart';
import '../model/user.dart';

// Provider pour le service d'authentification
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Provider pour la gestion de l'état d'authentification
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage(); // Instance SecureStorage

  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  // Fonction d'enregistrement
  Future<void> register(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(authServiceProvider).register(data);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Fonction de connexion
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response =
          await _ref.read(authServiceProvider).login(email, password);
      final user = response['user'];
      final token = response['token'];

      await _secureStorage.write(key: 'auth_token', value: token);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
