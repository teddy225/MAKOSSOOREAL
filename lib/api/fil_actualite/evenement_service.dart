import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';
import '../../database/databasehelper.dart';
import '../../model/event.dart'; // On suppose que vous avez un modèle 'Event'

class EventService {
  final flutterSecureStorage = FlutterSecureStorage();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://api.adminmakossoapp.com/api/v1/events', // Nouveau baseUrl pour les événements
    ),
  );
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Récupère les événements. Si un cache est disponible dans SQLite, il est utilisé.
  Future<List<Event>> recupererEvenements({int isFeeded = 0}) async {
    try {
      // Lire le token depuis FlutterSecureStorage
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      // Ajouter le token dans les headers
      _dio.options.headers['Authorization'] = 'Bearer $storedToken';

      // Point d'API pour récupérer les événements. Vous pouvez ajouter une condition isFeeded si nécessaire.
      final endpoint = isFeeded == 1
          ? '/feeded'
          : ''; // Peut être modifié en fonction de votre API
      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            List<Event> events =
                (response.data['data'] as List).map((eventJson) {
              return Event.fromJson(
                  eventJson); // Créez un constructeur fromJson dans le modèle 'Event'
            }).toList();

            // Optionnel : Filtrer si nécessaire, par exemple si vous ne voulez que certains types d'événements.

            print(events);
            return events;
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
      } else if (e is TimeoutException) {
        throw Exception('Erreur de délai dépassé');
      } else {
        print('Erreur inattendue: $e');
        throw Exception('Erreur inattendue: $e');
      }
    }
  }
}
