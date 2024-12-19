import 'dart:async'; // Import pour gérer les futures et les délais.
import 'dart:convert';
import 'package:dio/dio.dart'; // Bibliothèque Dio pour effectuer des requêtes HTTP.
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Pour stocker et récupérer les données de manière sécurisée.
import 'package:retry/retry.dart'; // Pour réessayer les requêtes en cas d'échec.
import '../model/commentaire.dart'; // Import du modèle de commentaire.

class CommentService {
  // Instance de FlutterSecureStorage pour accéder au token stocké.
  final flutterSecureStorage = FlutterSecureStorage();

  // Initialisation de Dio avec une URL de base pour les appels API.

  /// Fonction pour récupérer les commentaires d'une publication spécifique.
  /// Nécessite l'ID de la publication.
  final Dio _dio = Dio();

  /// Fonction pour récupérer les commentaires d'une publication spécifique.
  /// Nécessite l'ID de la publication.
  Future<dynamic> recupererCommentaires({required int postId}) async {
    try {
      // Lire le token depuis FlutterSecureStorage
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      // Ajout du token d'authentification dans les en-têtes HTTP.
      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      final String apiUrl =
          'https://api.adminmakossoapp.com/api/v1/comments/$postId';

      // Utiliser retry pour gérer les tentatives.
      final response = await retry(
        () async {
          final response = await _dio.get(apiUrl);
          if (response.statusCode == 200) {
            return response;
          } else {
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).timeout(const Duration(seconds: 30));

      List<Comment> commentaires = (response.data['data'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList();

      return commentaires;
    } catch (e) {
      // Gestion des erreurs.
      print('Erreur: $e');
      throw Exception('Erreur lors de la récupération des commentaires. $e');
    }
  }

  /// Fonction pour récupérer l'ID de l'utilisateur à partir du token.
  Future<int?> getUserIdFromToken() async {
    final token = await flutterSecureStorage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      // Décodage du token JWT pour extraire les données utilisateur
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final decodedPayload = base64Url.decode(base64Url.normalize(payload));
          final jsonPayload = json.decode(utf8.decode(decodedPayload));
          return jsonPayload[
              'user_id']; // 'user_id' dépend de votre payload JWT
        }
      } catch (e) {
        print(
            "Erreur lors de l'extraction de l'ID utilisateur depuis le token : $e");
      }
    }
    return null;
  }

  /// Fonction pour ajouter un commentaire à une publication.
  Future<Comment> ajouterCommentaire({
    required int postId,
    required String contenu,
  }) async {
    try {
      // Récupération de l'ID de l'utilisateur depuis le token
      final userId = await getUserIdFromToken();
      if (userId == null) {
        throw Exception('L\'ID utilisateur est introuvable.');
      }

      // Récupération du token d'authentification stocké.
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      // Ajout du token d'authentification dans les en-têtes HTTP.
      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      // Données à envoyer dans le corps de la requête (contenu du commentaire et ID utilisateur).
      final data = {
        'post_id': postId,
        'content': contenu,
        'user_id': userId, // Ajout de l'ID de l'utilisateur
      };

      // Construction dynamique de l'URL pour ajouter le commentaire à une publication spécifique
      final String apiUrl =
          'https://api.adminmakossoapp.com/api/v1/comments/'; // Ici, on ajoute postId dans l'URL

      // Requête POST pour ajouter le commentaire.
      final response = await retry(
        () async {
          final response = await _dio.post(
            apiUrl, // Utilisation de l'URL dynamique ici
            data: data,
          );

          // Vérification de la réponse du serveur.
          if (response.statusCode == 201) {
            final comment = Comment.fromJson(response.data['data']);
            return comment;
          } else {
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        },
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
        onRetry: (e) => print('Nouvelle tentative après échec: $e'),
      ).timeout(const Duration(seconds: 30));

      return response;
    } catch (e) {
      if (e is DioException) {
        print('Erreur réseau: ${e.message}');
        if (e.response != null) {
          print(
              'Statut du serveur: ${e.response?.statusCode}, Message: ${e.response?.statusMessage}');
        }
        throw Exception('Erreur réseau: ${e.message}');
      } else {
        print('Erreur inattendue: $e');
        throw Exception('Erreur inattendue: $e');
      }
    }
  }
}
