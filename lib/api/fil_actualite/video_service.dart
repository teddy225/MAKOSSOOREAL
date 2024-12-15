import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:makosso_app/model/video_model.dart';
import 'package:retry/retry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoService {
  final flutterSecureStorage = FlutterSecureStorage();
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://api.adminmakossoapp.com/public/api/v1/posts'));

  Database? _database;

  /// Initialisation de SQLite
  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'videos.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE videos (
            id TEXT PRIMARY KEY,
            url TEXT,
            type TEXT,
            thumbnail BLOB
          )
        ''');
      },
    );
  }

  /// Générer une miniature pour une vidéo
  Future generateThumbnail(String videoPath) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // Taille de l'image
        quality: 80, // Qualité de l'image
      );
      return uint8list;
    } catch (e) {
      print("Erreur lors de la génération de la miniature : $e");
      return null;
    }
  }

  /// Sauvegarder les vidéos dans SQLite
  Future<void> saveVideosToDatabase(List<VideoModel> videos) async {
    if (_database == null) {
      throw Exception("Base de données non initialisée");
    }

    final batch = _database!.batch();
    for (var video in videos) {
      batch.insert(
        'videos',
        {
          'id': video.id,
          'url': video.url,
          'type': video.type,
          'thumbnail': video.thumbnail,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Récupérer les vidéos depuis SQLite
  Future<List<VideoModel>> getVideosFromDatabase() async {
    if (_database == null) {
      throw Exception("Base de données non initialisée");
    }

    final maps = await _database!.query('videos');

    return List.generate(
      maps.length,
      (i) => VideoModel(
        id: maps[i]['id'] as int,
        url: maps[i]['url'] as String,
        type: maps[i]['type'] as String,
        thumbnail: maps[i]['thumbnail'] as Uint8List,
        uid: '',
        title: '',
        description: '',
        is_feeded: 0,
      ),
    );
  }

  /// Récupère les vidéos (cache ou API)
  Future<List<VideoModel>> recuprervideoListe({int isFeeded = 0}) async {
    try {
      // Charger les vidéos depuis SQLite
      final cachedVideos = await getVideosFromDatabase();
      if (cachedVideos.isNotEmpty) {
        print("Chargement des vidéos depuis le cache SQLite");
        return cachedVideos;
      }

      // Récupérer le token
      final storedToken = await flutterSecureStorage.read(key: 'auth_token');
      if (storedToken == null || storedToken.isEmpty) {
        throw Exception('Le token est introuvable ou invalide.');
      }

      _dio.options.headers['Authorization'] = 'Bearer $storedToken';
      final endpoint = isFeeded == 1 ? '/feeded' : '';

      // Requête API avec gestion des tentatives
      final response = await retry(
        () async {
          final response = await _dio.get(endpoint);
          if (response.statusCode == 200) {
            List<VideoModel> videos = (response.data as List)
                .map((videoJson) => VideoModel.fromJson(videoJson))
                .toList();
            videos = videos
                .where((publication) => publication.type == 'video')
                .toList();

            // Générer les miniatures et sauvegarder dans SQLite
            for (var video in videos) {
              video.thumbnail =
                  await generateThumbnail('adminmakossoapp.com/${video.url}');
            }

            await saveVideosToDatabase(videos);
            print('Vidéos sauvegardées dans SQLite');
            return videos;
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
