import 'dart:async';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';
import '../../database/databasehelper.dart';
import '../../model/text_publication.dart';

class TextpublicationService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://adminmakossoapp.com/public/api/posts'));

  /// Récupère les publications de l'actualité. Si un cache est disponible dans SQLite, il est utilisé.
  /// Sinon, une requête API est effectuée.
  Future<List<TextPublication>> recupererPublicationText(
      {int isFeeded = 0}) async {
    try {
      // Construire l'endpoint basé sur le paramètre 'isFeeded'
      final endpoint = isFeeded == 1 ? '/feeded' : '';

      // Effectuer la requête avec une gestion des tentatives de reconnexion en cas d'échec
      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            // Transformer les données de la réponse en objets TextPublication
            List<TextPublication> publications = (response.data as List)
                .map((publicationJson) =>
                    TextPublication.fromJson(publicationJson))
                .toList();
            publications = publications
                .where((publication) => publication.type == 'text')
                .toList();

            // Sauvegarder les données dans SQLite pour le cache

            print('Réponse texte réussie: $publications');
            return publications;
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
      if (e is DioError) {
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
