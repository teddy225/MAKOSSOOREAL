import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/api/fil_actualite/video_service.dart';
import 'package:makosso_app/model/video_model.dart';

// Instance du service pour récupérer les données
final videoProviderService = Provider((ref) => VideoService());

final videoProviderList = FutureProvider<List<VideoModel>>((ref) async {
  final service = ref.watch(videoProviderService);
  return service.recuprervideoListe(isFeeded: 0);
});
final selectedVideoProvider = StateProvider<VideoModel?>((ref) => null);
