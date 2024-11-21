
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/fil_actualite/fil_actualitte.dart';
import '../model/filactualite.dart';

// Instance du service pour récupérer les données
final filActualiteServiceProvider = Provider((ref) => FilActualitService());

// FutureProvider pour la récupération des posts
final filActualiteProvider =
FutureProvider.family<List<FilActualite>, int>((ref, isFeeded) async {
  final service = ref.watch(filActualiteServiceProvider);
  return await service.recupererfilactualite(isFeeded: isFeeded);
});