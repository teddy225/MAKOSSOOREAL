import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:makosso_app/model/video_model.dart';
import 'package:retry/retry.dart';

class VideoService {
  final flutterSecureStorage = FlutterSecureStorage();

  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://api.adminmakossoapp.com/public/api/v1/posts'));

  /// Récupère les videos de l'actualité. Si un cache est disponible dans SQLite, il est utilisé.
  /// Sinon, une requête API est effectuée.
  Future<List<VideoModel>> recuprervideoListe({int isFeeded = 0}) async {
    try {
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }
      print(storedToken);
      // Ajouter le token dans les headers
      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      // Construire l'endpoint basé sur le paramètre 'isFeeded'
      final endpoint = isFeeded == 1 ? '/feeded' : '';

      // Effectuer la requête avec une gestion des tentatives de reconnexion en cas d'échec
      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            // Transformer les données de la réponse en objets VideoModel
            List<VideoModel> videos = (response.data as List)
                .map((videoJson) => VideoModel.fromJson(videoJson))
                .toList();
            videos = videos
                .where((publication) => publication.type == 'video')
                .toList();

            // Sauvegarder les données dans SQLite pour le cache

            print('Réponse texte réussie: $videos');
            return videos;
          } else {
            // En cas d'erreur de réponse (par exemple, 404 ou 500)
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
            );
          }
        },
        // Conditions pour réessayer en cas d'échec réseau ou timeout
        retryIf: (e) => e is DioException || e is TimeoutException,
        maxAttempts: 3, // Nombre de tentatives de reconnection
        delayFactor: const Duration(seconds: 2), // Délai entre chaque tentative
        onRetry: (e) => print('Nouvelle tentative après échec: $e'),
      ).timeout(const Duration(seconds: 30)); // Délai maximal pour la requête

      // Retourner les videos récupérées
      return response;
    } catch (e) {
      // Gestion des erreurs réseau spécifiques à Dio
      if (e is DioException) {
        print('Erreur réseau: ${e.message}');
        if (e.response != null) {
          print(
              'Statut du serveur: ${e.response?.statusCode}, Message: ${e.response?.statusMessage}');
        }
        throw Exception('Erreur réseau: ${e.message}');
      } else if (e is TimeoutException) {
        // Gestion des erreurs de délai
        throw Exception('Erreur de délai dépassé');
      } else {
        // Gestion des erreurs inattendues
        print('Erreur inattendue: $e');
        throw Exception('Erreur inattendue: $e');
      }
    }
  }
}
