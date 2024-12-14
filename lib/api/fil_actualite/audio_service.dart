import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:makosso_app/model/audio_model.dart';
import 'package:retry/retry.dart';

class AudioService {
  final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  final Dio _dio;

  AudioService({required Dio dio}) : _dio = dio;

  Future<List<AudioModel>> recupererAudio({int isFeeded = 0}) async {
    try {
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $storedToken';
      final endpoint = isFeeded == 1 ? '/feeded' : '';

      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            List<AudioModel> audios = (response.data as List)
                .map((audioJson) => AudioModel.fromJson(audioJson))
                .toList();
            return audios.where((audio) => audio.type == 'audio').toList();
          } else {
            throw DioError(requestOptions: response.requestOptions);
          }
        },
        retryIf: (e) => e is DioError || e is TimeoutException,
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      );

      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des audios: $e');
    }
  }
}
