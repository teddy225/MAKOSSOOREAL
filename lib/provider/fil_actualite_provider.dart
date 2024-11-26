import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/fil_actualite/fil_actualitte.dart';
import '../model/filactualite.dart';

// Instance du service pour récupérer les données
final filActualiteServiceProvider = Provider((ref) => FilActualitService());

final filActualiteStreamProvider = StreamProvider<List<FilActualite>>((ref) {
  final service = ref.watch(filActualiteServiceProvider);
  return service.filActualiteStream;
});
