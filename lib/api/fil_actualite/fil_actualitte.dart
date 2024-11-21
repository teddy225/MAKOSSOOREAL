import 'dart:async';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import '../../database/databasehelper.dart';
import '../../model/filactualite.dart';

class FilActualitService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://adminmakossoapp.com/public/api/posts'));
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Récupère les publications de l'actualité. Si un cache est disponible dans SQLite, il est utilisé.
  /// Sinon, une requête API est effectuée.
  Future<List<FilActualite>> recupererfilactualite({int isFeeded = 1}) async {
    try {
      // Vérifier si des données sont déjà en cache
      final cache = await _dbHelper.getFilActualite();
      if (cache.isNotEmpty) {
        // Si des données sont en cache, on les retourne
        print('en cache');
        print(cache.map((data) => FilActualite.fromJson(data)).toList());
        return cache.map((data) => FilActualite.fromJson(data)).toList();
      }

      // Construire l'endpoint basé sur le paramètre 'isFeeded'
      final endpoint = isFeeded == 1 ? '/feeded' : '';

      // Effectuer la requête avec une gestion des tentatives de reconnexion en cas d'échec
      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            // Transformer les données de la réponse en objets FilActualite
            List<FilActualite> postes =
                (response.data as List).map((postesJson) {
              return FilActualite.fromJson(postesJson);
            }).toList();
            postes = postes
                .where((publication) => publication.type == 'image')
                .toList();
            // Sauvegarder les données dans SQLite pour le cache
            await _dbHelper
                .insertFilActualite(postes.map((p) => p.toJson()).toList());

            print('Réponse Publication fil réussie: $postes');
            return postes;
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

      // Retourner les publications récupérées
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
